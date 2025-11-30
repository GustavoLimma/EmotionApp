import 'package:cloud_firestore/cloud_firestore.dart'; // ADICIONE ESTE IMPORT

class MoodEntry {
  final String emoji;
  final DateTime timestamp;
  final String? note;
  final String? documentId;

  MoodEntry({
    required this.emoji,
    required this.timestamp,
    this.note,
    this.documentId,
  });

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'timestamp': Timestamp.fromDate(timestamp), // CORREÇÃO AQUI
      'note': note ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Criar a partir de Map (para carregar do Firestore)
  factory MoodEntry.fromMap(Map<String, dynamic> map, String documentId) {
    return MoodEntry(
      emoji: map['emoji'] ?? '😐',
      timestamp: (map['timestamp'] as Timestamp).toDate(), // CORREÇÃO AQUI
      note: map['note']?.isNotEmpty == true ? map['note'] : null,
      documentId: documentId,
    );
  }

  @override
  String toString() {
    return 'MoodEntry(emoji: $emoji, timestamp: $timestamp, note: $note)';
  }
}