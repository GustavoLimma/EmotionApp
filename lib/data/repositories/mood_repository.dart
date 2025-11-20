// lib/data/repositories/mood_repository.dart
import 'package:emotion_app/data/models/mood_entry.dart';
import 'package:emotion_app/data/services/mood_service.dart';

class MoodRepository {
  final MoodService _service;

  MoodRepository(this._service);

  Future<void> addMood(String emoji, String? note) async {
    final entry = MoodEntry(
      emoji: emoji,
      timestamp: DateTime.now(),
      note: note,
    );
    return _service.addEntry(entry);
  }

  Future<List<MoodEntry>> getAll() async {
    return _service.fetchEntries();
  }
}
