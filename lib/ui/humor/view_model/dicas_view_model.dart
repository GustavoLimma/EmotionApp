import 'package:flutter/material.dart';
import 'package:emotion_app/data/repositories/humor_repository.dart';
import 'package:emotion_app/data/models/humor_model.dart';
import 'package:emotion_app/utils/command.dart';
import 'package:emotion_app/utils/result.dart';

class TipsViewModel extends ChangeNotifier {
  final MoodRepository? _repository;

  final List<MoodEntry> _entries = [];
  final List<Tip> _tips = [];

  late Command<void, void> loadTipsCommand;

  TipsViewModel({MoodRepository? repository}) : _repository = repository {
    loadTipsCommand = Command<void, void>(_loadTips);
    loadTipsCommand.executeNoArgs(); // carrega automaticamente
  }

  List<Tip> get tips => _tips;
  bool get hasData => _entries.isNotEmpty;

  // ------------------- COMMAND ACTION -------------------
  Future<Result<void>> _loadTips(void _) async {
    try {
      if (_repository != null) {
        _entries.clear();
        _entries.addAll(await _repository.getAll());
      }

      _generateTips();
      notifyListeners();
      return Ok(null);
    } catch (e) {
      return Error("Erro ao carregar dicas");
    }
  }

  // ------------------- GERAR DICAS -------------------
  void _generateTips() {
    _tips.clear();

    if (_entries.isEmpty) {
      _tips.add(
        Tip(
          title: "Comece a registrar seu humor",
          description:
              "Registre como você está se sentindo para receber dicas personalizadas",
          category: TipCategory.general,
          emoji: "📝",
        ),
      );
      return;
    }

    final last7 = _getLast7DaysEntries();
    final analysis = _analyzeMoodPatterns(last7);

    _generateMoodBasedTips(analysis);
    _generateGeneralTips();
  }

  List<MoodEntry> _getLast7DaysEntries() {
    final now = DateTime.now();
    final sevenAgo = now.subtract(const Duration(days: 7));

    return _entries.where((e) => e.timestamp.isAfter(sevenAgo)).toList();
  }

  MoodAnalysis _analyzeMoodPatterns(List<MoodEntry> recent) {
    if (recent.isEmpty) return MoodAnalysis();

    int sad = 0, stressed = 0, neutral = 0, happy = 0;

    for (var e in recent) {
      switch (e.emoji) {
        case '😢':
        case '😕':
          sad++;
          break;
        case '😡':
          stressed++;
          break;
        case '😐':
          neutral++;
          break;
        case '😀':
        case '🙂':
        case '🤩':
          happy++;
          break;
      }
    }

    return MoodAnalysis(
      totalEntries: recent.length,
      sadPercentage: (sad / recent.length) * 100,
      stressedPercentage: (stressed / recent.length) * 100,
      neutralPercentage: (neutral / recent.length) * 100,
      happyPercentage: (happy / recent.length) * 100,
    );
  }

  void _generateMoodBasedTips(MoodAnalysis a) {
    if (a.sadPercentage > 30) {
      _tips.add(Tip(
        title: "Atividade Física Leve",
        description:
            "Uma caminhada de 15 minutos pode melhorar seu humor naturalmente",
        category: TipCategory.exercise,
        emoji: "🚶‍♂️",
        duration: "15 min",
      ));

      _tips.add(Tip(
        title: "Meditação Guiada",
        description: "Uma meditação curta pode ajudar a acalmar a mente",
        category: TipCategory.meditation,
        emoji: "🧘‍♀️",
        duration: "10 min",
      ));
    }

    if (a.stressedPercentage > 20) {
      _tips.add(Tip(
        title: "Respiração 4-7-8",
        description: "Exercício de respiração para reduzir ansiedade",
        category: TipCategory.meditation,
        emoji: "🌬️",
        duration: "5 min",
      ));
    }

    if (a.neutralPercentage > 50) {
      _tips.add(Tip(
        title: "Leitura Inspiradora",
        description: "Leia algo leve para estimular novas ideias",
        category: TipCategory.reading,
        emoji: "📚",
        duration: "20 min",
      ));
    }

    if (a.happyPercentage > 60) {
      _tips.add(Tip(
        title: "Continue Assim!",
        description:
            "Mantenha as atividades que estão alimentando seu bem-estar!",
        category: TipCategory.general,
        emoji: "🌟",
      ));
    }
  }

  void _generateGeneralTips() {
    _tips.addAll([
      Tip(
        title: "Journaling",
        description: "Escrever seus pensamentos melhora o bem-estar emocional",
        category: TipCategory.general,
        emoji: "📓",
        duration: "10 min",
      ),
      Tip(
        title: "Hidratação",
        description: "Manter-se hidratado impacta diretamente seu humor",
        category: TipCategory.general,
        emoji: "💧",
      ),
    ]);
  }

  // Comando para atualizar manualmente
  void refreshTips() => loadTipsCommand.executeNoArgs();
}

// --------------------- MODELS -----------------------
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

enum TipCategory { meditation, exercise, reading, resources, general }

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
