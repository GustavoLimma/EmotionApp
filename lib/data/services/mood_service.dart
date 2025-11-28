import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_app/data/models/mood_entry.dart';

class MoodService {
  MoodService() {
    _db = FirebaseFirestore.instance;
  }

  late final FirebaseFirestore _db;

  Future<void> addEntry(MoodEntry entry) async {
    try {
      final entryMap = {
        'emoji': entry.emoji,
        'timestamp': entry.timestamp,
        'note': entry.note ?? '',
        // Removido o userId já que não há autenticação
      };

      await _db
          .collection('mood_entries')
          .add(entryMap);
    } catch (e) {
      throw Exception('Erro ao salvar no Firebase: $e');
    }
  }

  Future<List<MoodEntry>> fetchEntries() async {
    try {
      final querySnapshot = await _db
          .collection('mood_entries')
          .orderBy('timestamp', descending: true)
          .get(); // Removido o filtro por userId

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MoodEntry(
          emoji: data['emoji'] ?? '😐',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          note: data['note']?.isNotEmpty == true ? data['note'] : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar do Firebase: $e');
    }
  }
}