// lib/ui/mood/mood_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:emotion_app/data/repositories/humor_repository.dart';
import 'package:emotion_app/utils/command.dart';
import 'package:emotion_app/utils/result.dart';
import 'package:emotion_app/data/models/humor_model.dart';

class MoodViewModel extends ChangeNotifier {
  MoodViewModel(this._repository) {
    loadMoods = Command<List<MoodEntry>, void>(_loadMoods)..executeNoArgs();
    addMood = Command<void, ({String emoji, String? note})>(_addMood);
  }

  final MoodRepository _repository;

  late Command<List<MoodEntry>, void> loadMoods;
  late Command<void, ({String emoji, String? note})> addMood;

  List<MoodEntry> _entries = [];
  List<MoodEntry> get entries => _entries;

  // --------- LOAD MOODS ---------
  Future<Result<List<MoodEntry>>> _loadMoods(void _) async {
    try {
      final list = await _repository.getAll();
      _entries = list;
      return Ok(list);
    } catch (e) {
      return Error("Erro ao carregar humor");
    } finally {
      notifyListeners();
    }
  }

  // --------- ADD MOOD ---------
  Future<Result<void>> _addMood(({String emoji, String? note}) args) async {
    try {
      await _repository.addMood(args.emoji, args.note);
      return Ok(null);
    } catch (e) {
      return Error("Erro ao registrar humor");
    } finally {
      await loadMoods.executeNoArgs(); 
      notifyListeners();
    }
  }
}
