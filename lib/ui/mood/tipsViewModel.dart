import 'package:flutter/material.dart';
import 'package:emotion_app/data/repositories/mood_repository.dart';
import 'package:emotion_app/data/models/mood_entry.dart';

class TipsViewModel extends ChangeNotifier {
  final MoodRepository? _repository;
  final List<MoodEntry> _entries = []; // TORNE FINAL
  final List<Tip> _tips = []; // TORNE FINAL

  TipsViewModel({MoodRepository? repository}) : _repository = repository {
    _loadData();
  }

  List<Tip> get tips => _tips;
  bool get hasData => _entries.isNotEmpty;

  Future<void> _loadData() async {
    if (_repository != null) {
      _entries.addAll(await _repository!.getAll()); // USE addAll
      _generateTips();
      notifyListeners();
    }
  }

  void _generateTips() {
    _tips.clear();

    if (_entries.isEmpty) {
      _tips.add(Tip(
        title: "Comece a registrar seu humor",
        description: "Registre como você está se sentindo para receber dicas personalizadas",
        category: TipCategory.general,
        emoji: "📝",
      ));
      return;
    }

    final last7Days = _getLast7DaysEntries();
    final moodAnalysis = _analyzeMoodPatterns(last7Days);

    _generateMoodBasedTips(moodAnalysis);
    _generateGeneralTips();
  }

  List<MoodEntry> _getLast7DaysEntries() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    return _entries.where((entry) => 
        entry.timestamp.isAfter(sevenDaysAgo)).toList();
  }

  MoodAnalysis _analyzeMoodPatterns(List<MoodEntry> recentEntries) {
    if (recentEntries.isEmpty) return MoodAnalysis();

    int sadCount = 0;
    int stressedCount = 0;
    int neutralCount = 0;
    int happyCount = 0;

    for (var entry in recentEntries) {
      switch (entry.emoji) {
        case '😢':
        case '😕':
          sadCount++;
          break;
        case '😡':
          stressedCount++;
          break;
        case '😐':
          neutralCount++;
          break;
        case '😀':
        case '🙂':
        case '🤩':
          happyCount++;
          break;
      }
    }

    return MoodAnalysis(
      totalEntries: recentEntries.length,
      sadPercentage: (sadCount / recentEntries.length) * 100,
      stressedPercentage: (stressedCount / recentEntries.length) * 100,
      neutralPercentage: (neutralCount / recentEntries.length) * 100,
      happyPercentage: (happyCount / recentEntries.length) * 100,
    );
  }

  void _generateMoodBasedTips(MoodAnalysis analysis) {
    if (analysis.sadPercentage > 30) {
      _tips.add(Tip(
        title: "Atividade Física Leve",
        description: "Uma caminhada de 15 minutos pode melhorar seu humor naturalmente",
        category: TipCategory.exercise,
        emoji: "🚶‍♂️",
        duration: "15 min",
      ));

      _tips.add(Tip(
        title: "Meditação Guiada",
        description: "Experimente uma meditação de 10 minutos para acalmar a mente",
        category: TipCategory.meditation,
        emoji: "🧘‍♀️",
        duration: "10 min",
        resource: "App: Insight Timer",
      ));
    }

    if (analysis.stressedPercentage > 20) {
      _tips.add(Tip(
        title: "Respiração 4-7-8",
        description: "Técnica de respiração para reduzir ansiedade instantaneamente",
        category: TipCategory.meditation,
        emoji: "🌬️",
        duration: "5 min",
      ));

      _tips.add(Tip(
        title: "Alongamento Corporal",
        description: "Libere a tensão muscular com alongamentos simples",
        category: TipCategory.exercise,
        emoji: "💪",
        duration: "10 min",
      ));
    }

    if (analysis.neutralPercentage > 50) {
      _tips.add(Tip(
        title: "Leitura Inspiradora",
        description: "Um livro interessante pode estimular novas perspectivas",
        category: TipCategory.reading,
        emoji: "📚",
        duration: "20 min",
        resource: "Sugestão: 'O Poder do Agora'",
      ));
    }

    if (analysis.happyPercentage > 60) {
      _tips.add(Tip(
        title: "Mantenha o Momentum",
        description: "Continue com as atividades que estão te fazendo bem!",
        category: TipCategory.general,
        emoji: "🌟",
      ));
    }
  }

  void _generateGeneralTips() {
    _tips.addAll([
      Tip(
        title: "Journaling Diário",
        description: "Escrever sobre seus pensamentos pode trazer clareza mental",
        category: TipCategory.general,
        emoji: "📓",
        duration: "10 min",
      ),
      Tip(
        title: "Hidratação Consciente",
        description: "Beber água regularmente melhora o foco e o bem-estar",
        category: TipCategory.general,
        emoji: "💧",
      ),
      Tip(
        title: "Podcast: Saúde Mental",
        description: "Episódio sobre gerenciamento de emoções do dia a dia",
        category: TipCategory.resources,
        emoji: "🎧",
        resource: "Podcast: 'Psicologia na Prática'",
        duration: "45 min",
      ),
      Tip(
        title: "Artigo: Neurociência das Emoções",
        description: "Entenda como seu cérebro processa diferentes emoções",
        category: TipCategory.resources,
        emoji: "🧠",
        resource: "Leitura online - 8 min",
      ),
    ]);
  }

  void refreshTips() {
    _loadData();
  }
}

class MoodAnalysis {
  final int totalEntries;
  final double sadPercentage;
  final double stressedPercentage;
  final double neutralPercentage;
  final double happyPercentage;

  MoodAnalysis({
    this.totalEntries = 0,
    this.sadPercentage = 0,
    this.stressedPercentage = 0,
    this.neutralPercentage = 0,
    this.happyPercentage = 0,
  });
}

class Tip {
  final String title;
  final String description;
  final TipCategory category;
  final String emoji;
  final String? duration;
  final String? resource;

  Tip({
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    this.duration,
    this.resource,
  });
}

enum TipCategory {
  meditation,
  exercise,
  reading,
  resources,
  general,
}

extension TipCategoryExtension on TipCategory {
  String get displayName {
    switch (this) {
      case TipCategory.meditation:
        return "Meditação";
      case TipCategory.exercise:
        return "Exercício";
      case TipCategory.reading:
        return "Leitura";
      case TipCategory.resources:
        return "Recursos";
      case TipCategory.general:
        return "Geral";
    }
  }

  Color get color {
    switch (this) {
      case TipCategory.meditation:
        return Colors.purple;
      case TipCategory.exercise:
        return Colors.green;
      case TipCategory.reading:
        return Colors.blue;
      case TipCategory.resources:
        return Colors.orange;
      case TipCategory.general:
        return Colors.grey;
    }
  }
}