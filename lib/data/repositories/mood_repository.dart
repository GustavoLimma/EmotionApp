// lib/data/repositories/mood_repository.dart
import 'dart:async'; 
import 'package:emotion_app/data/models/mood_entry.dart';
import 'package:emotion_app/data/services/mood_service.dart';

class MoodRepository {
  final MoodService _service;
  
  // Stream para notificar mudanças nos dados
  final StreamController<List<MoodEntry>> _entriesController = 
      StreamController<List<MoodEntry>>.broadcast();
  
  Stream<List<MoodEntry>> get entriesStream => _entriesController.stream;

  MoodRepository(this._service);

  Future<void> addMood(String emoji, String? note) async {
    final entry = MoodEntry(
      emoji: emoji,
      timestamp: DateTime.now(),
      note: note,
    );
    await _service.addEntry(entry);
    
    // Notifica sobre a mudança
    final allEntries = await _service.fetchEntries();
    _entriesController.add(allEntries);
  }

  Future<List<MoodEntry>> getAll() async {
    return _service.fetchEntries();
  }

  void dispose() {
    _entriesController.close();
  }
}