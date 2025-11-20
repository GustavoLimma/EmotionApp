// lib/data/services/mood_service.dart
import 'package:emotion_app/data/models/mood_entry.dart';

class MoodService {
  MoodService();

  final List<MoodEntry> _entries = [];

  Future<void> addEntry(MoodEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula API
    _entries.add(entry);
  }

  Future<List<MoodEntry>> fetchEntries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_entries); // segurança
  }
}
