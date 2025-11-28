import 'dart:async';
import 'package:flutter/material.dart';
import 'package:emotion_app/data/repositories/mood_repository.dart';
import 'package:emotion_app/data/models/mood_entry.dart';

enum DashboardPeriod { weekly, monthly }

class DashboardViewModel extends ChangeNotifier {
  final MoodRepository? _repository;
  DashboardPeriod _period = DashboardPeriod.weekly;
  List<MoodEntry> _allEntries = [];
  String? _errorMessage;
  
  StreamSubscription<List<MoodEntry>>? _entriesSubscription;

  DashboardViewModel({MoodRepository? repository}) : _repository = repository {
    _entriesSubscription = _repository?.entriesStream.listen(_updateData);
    _loadInitialData();
  }

  DashboardPeriod get period => _period;
  List<double>? lineChartData;
  Map<String, double>? pieChartData;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

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
    try {
      _errorMessage = null;
      if (_repository != null) {
        _allEntries = await _repository!.getAll();
        _updateCharts();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: $e';
      lineChartData = null;
      pieChartData = null;
      notifyListeners();
    }
  }

  void _updateData(List<MoodEntry> entries) {
    try {
      _errorMessage = null;
      _allEntries = entries;
      _updateCharts();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao atualizar dados: $e';
      notifyListeners();
    }
  }

  void _updateCharts() {
    if (_allEntries.isEmpty) {
      lineChartData = null;
      pieChartData = null;
      return;
    }

    _updatePieChart();

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
    // REMOVA as variáveis não utilizadas:
    // final firstDayOfMonth = DateTime(now.year, now.month, 1);
    // final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Divide o mês em 4 semanas fixas
    lineChartData = List<double>.filled(4, 0.0);
    
    for (var entry in _allEntries) {
      if (entry.timestamp.year == now.year && entry.timestamp.month == now.month) {
        final day = entry.timestamp.day;
        final weekIndex = _getWeekIndex(day);
        if (weekIndex >= 0 && weekIndex < 4) {
          lineChartData![weekIndex] += 1;
        }
      }
    }
  }

  int _getWeekIndex(int day) {
    if (day <= 7) return 0;
    if (day <= 14) return 1;
    if (day <= 21) return 2;
    return 3;
  }

  // GRÁFICO DE BARRAS SIMPLIFICADO
  Widget _buildBarChart() {
    final maxValue = lineChartData!.reduce((a, b) => a > b ? a : b);
    
    List<String> labels;
    if (_period == DashboardPeriod.weekly) {
      labels = ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'D-1', 'Hoje'];
    } else {
      labels = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4+'];
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _period == DashboardPeriod.weekly 
                ? "Registros dos Últimos 7 Dias"
                : "Registros do Mês por Semana",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: lineChartData!.asMap().entries.map((entry) {
                final value = entry.value;
                final max = maxValue > 0 ? maxValue : 1.0;
                final height = (value / max) * 120;
                final barWidth = _period == DashboardPeriod.weekly ? 25 : 30;
                final fontSize = _period == DashboardPeriod.weekly ? 12 : 11;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: barWidth.toDouble(),
                      height: height,
                      decoration: BoxDecoration(
                        color: _getBarColor(value),
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: _getBarGradientColors(),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize.toDouble(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 45,
                      child: Text(
                        labels[entry.key],
                        style: TextStyle(fontSize: _period == DashboardPeriod.weekly ? 12 : 10),
                        textAlign: TextAlign.center,
                        maxLines: 2,
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

  List<Color> _getBarGradientColors() {
    if (_period == DashboardPeriod.weekly) {
      return [Colors.indigo.shade700, Colors.indigo.shade400];
    } else {
      return [Colors.purple.shade700, Colors.purple.shade400];
    }
  }

  Color _getBarColor(double value) {
    if (value == 0) return Colors.grey.shade400;
    if (value <= 1) return Colors.green;
    if (value <= 2) return Colors.blue;
    return _period == DashboardPeriod.weekly ? Colors.indigo : Colors.purple;
  }

  // VISUALIZAÇÃO DE PIZZA
  Widget _buildPieChartVisualization() {
    final total = pieChartData!.values.reduce((a, b) => a + b).toDouble();
    final maxCount = pieChartData!.values.reduce((a, b) => a > b ? a : b).toDouble();
    
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
                  'Total: ${total.toInt()} registros',
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