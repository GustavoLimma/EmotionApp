// CORRIGIDO - lib/ui/mood/dashboard_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:emotion_app/data/repositories/mood_repository.dart';
import 'package:emotion_app/data/models/mood_entry.dart';

enum DashboardPeriod { weekly, monthly }

class DashboardViewModel extends ChangeNotifier {
  final MoodRepository? _repository;
  DashboardPeriod _period = DashboardPeriod.weekly;
  List<MoodEntry> _allEntries = [];
  
  StreamSubscription<List<MoodEntry>>? _entriesSubscription;

  DashboardViewModel({MoodRepository? repository}) : _repository = repository {
    _entriesSubscription = _repository?.entriesStream.listen(_updateData);
    _loadInitialData();
  }

  DashboardPeriod get period => _period;
  List<double>? lineChartData;
  Map<String, double>? pieChartData;

  Widget? get lineChartWidget {
    if (lineChartData == null) return null;
    return _buildBarChart();
  }

  Widget? get pieChartWidget {
    if (pieChartData == null) return null;
    return _buildPieChartVisualization();
  }

  void changePeriod(DashboardPeriod newPeriod) {
    _period = newPeriod;
    _updateCharts();
    notifyListeners();
  }

  Future<void> _loadInitialData() async {
    if (_repository != null) {
      _allEntries = await _repository!.getAll();
      _updateCharts();
      notifyListeners();
    }
  }

  void _updateData(List<MoodEntry> entries) {
    _allEntries = entries;
    _updateCharts();
    notifyListeners();
  }

  void _updateCharts() {
    if (_allEntries.isEmpty) {
      lineChartData = null;
      pieChartData = null;
      return;
    }

    // SEMPRE atualiza o gráfico de pizza (é o mesmo para ambos os períodos)
    _updatePieChart();

    // Atualiza o gráfico de linha baseado no período selecionado
    if (_period == DashboardPeriod.weekly) {
      _updateWeeklyChart();
    } else {
      _updateMonthlyChart();
    }
  }

  void _updatePieChart() {
    pieChartData = {};
    for (var entry in _allEntries) {
      pieChartData!.update(
        entry.emoji,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
  }

  void _updateWeeklyChart() {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => 
        DateTime(now.year, now.month, now.day - i));
    
    lineChartData = last7Days.reversed.map((day) {
      final count = _allEntries.where((entry) => 
          entry.timestamp.year == day.year &&
          entry.timestamp.month == day.month &&
          entry.timestamp.day == day.day).length;
      return count.toDouble();
    }).toList();
  }

  void _updateMonthlyChart() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    // Cria uma lista com todos os dias do mês atual
    final daysOfMonth = List.generate(daysInMonth, (i) => 
        DateTime(now.year, now.month, i + 1));
    
    lineChartData = daysOfMonth.map((day) {
      final count = _allEntries.where((entry) => 
          entry.timestamp.year == day.year &&
          entry.timestamp.month == day.month &&
          entry.timestamp.day == day.day).length;
      return count.toDouble();
    }).toList();
  }

  // GRÁFICO DE BARRAS (agora adaptável ao período)
  Widget _buildBarChart() {
    final maxValue = lineChartData!.reduce((a, b) => a > b ? a : b);
    
    List<String> labels;
    if (_period == DashboardPeriod.weekly) {
      labels = ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'D-1', 'Hoje'];
    } else {
      // Para mensal, mostra semanas ou dias específicos
      final now = DateTime.now();
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      
      if (daysInMonth <= 31) {
        // Se o mês tem até 31 dias, mostra por semana
        labels = _getMonthlyWeekLabels();
      } else {
        // Para meses mais longos, mostra por década
        labels = _getMonthlyDecadeLabels();
      }
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _period == DashboardPeriod.weekly 
                ? "Registros dos Últimos 7 Dias"
                : "Registros do Mês Atual",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: lineChartData!.asMap().entries.map((entry) {
                final height = (entry.value / (maxValue > 0 ? maxValue : 1)) * 120;
                final label = entry.key < labels.length ? labels[entry.key] : '${entry.key + 1}';
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _period == DashboardPeriod.weekly ? 25 : 20, // Mais fino para mensal
                      height: height,
                      decoration: BoxDecoration(
                        color: _getBarColor(entry.value),
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            _period == DashboardPeriod.weekly 
                                ? Colors.indigo.shade700 
                                : Colors.purple.shade700,
                            _period == DashboardPeriod.weekly 
                                ? Colors.indigo.shade400 
                                : Colors.purple.shade400,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          entry.value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10, // Texto menor para mensal
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: _period == DashboardPeriod.weekly ? 12 : 10,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getMonthlyWeekLabels() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final weeksInMonth = (daysInMonth / 7).ceil();
    
    return List.generate(weeksInMonth, (i) => 'S${i + 1}');
  }

  List<String> _getMonthlyDecadeLabels() {
    return ['1-10', '11-20', '21-31', '32+'];
  }

  // VISUALIZAÇÃO DE PIZZA (mantém igual)
  Widget _buildPieChartVisualization() {
    final total = pieChartData!.values.reduce((a, b) => a + b);
    final maxCount = pieChartData!.values.reduce((a, b) => a > b ? a : b);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distribuição de Emoções ${_period == DashboardPeriod.weekly ? '(Semana)' : '(Mês)'}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
              children: pieChartData!.entries.map((entry) {
                final percentage = (entry.value / total * 100).round();
                final size = (entry.value / maxCount * 40) + 25;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: _getColorForEmoji(entry.key),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          entry.key,
                          style: TextStyle(fontSize: size * 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getEmojiName(entry.key),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _period == DashboardPeriod.weekly 
                  ? Colors.indigo.shade50 
                  : Colors.purple.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics, 
                  color: _period == DashboardPeriod.weekly 
                      ? Colors.indigo 
                      : Colors.purple, 
                  size: 14
                ),
                const SizedBox(width: 6),
                Text(
                  'Total: $total registros',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _period == DashboardPeriod.weekly 
                        ? Colors.indigo 
                        : Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBarColor(double value) {
    if (value == 0) return Colors.grey;
    if (value <= 1) return Colors.green;
    if (value <= 2) return Colors.blue;
    return _period == DashboardPeriod.weekly ? Colors.indigo : Colors.purple;
  }

  Color _getColorForEmoji(String emoji) {
    final colors = {
      '😀': Colors.green,
      '🙂': Colors.lightGreen,
      '😐': Colors.amber,
      '😕': Colors.orange,
      '😢': Colors.blue,
      '😡': Colors.red,
      '🤩': Colors.purple,
    };
    return colors[emoji] ?? Colors.grey;
  }

  String _getEmojiName(String emoji) {
    final names = {
      '😀': 'M.Feliz',
      '🙂': 'Feliz', 
      '😐': 'Neutro',
      '😕': 'Confuso',
      '😢': 'Triste',
      '😡': 'Irritado',
      '🤩': 'Animado',
    };
    return names[emoji] ?? emoji;
  }

  @override
  void dispose() {
    _entriesSubscription?.cancel();
    super.dispose();
  }
}