// lib/data/models/mood_entry.dart
class MoodEntry {
  final String emoji;
  final DateTime timestamp;
  final String? note;

  MoodEntry({
    required this.emoji,
    required this.timestamp,
    this.note,
  });
}
