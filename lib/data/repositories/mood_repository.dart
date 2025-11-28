import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_app/data/models/mood_entry.dart';
import 'package:emotion_app/data/services/mood_service.dart';

class MoodRepository {
  final MoodService _service;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Stream para notificar mudanças nos dados em tempo real
  final StreamController<List<MoodEntry>> _entriesController = 
      StreamController<List<MoodEntry>>.broadcast();
  
  Stream<List<MoodEntry>> get entriesStream => _entriesController.stream;
  StreamSubscription<QuerySnapshot>? _firestoreSubscription;

  MoodRepository(this._service) {
    _setupRealtimeUpdates();
  }

  void _setupRealtimeUpdates() {
    _firestoreSubscription = _db
        .collection('mood_entries')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
          final entries = snapshot.docs.map((doc) {
            final data = doc.data();
            return MoodEntry(
              emoji: data['emoji'] ?? '😐',
              timestamp: (data['timestamp'] as Timestamp).toDate(),
              note: data['note']?.isNotEmpty == true ? data['note'] : null,
            );
          }).toList();
          _entriesController.add(entries);
        });
  }

  Future<void> addMood(String emoji, String? note) async {
    await _service.addEntry(MoodEntry(
      emoji: emoji,
      timestamp: DateTime.now(),
      note: note,
    ));
    // O stream do Firestore já notificará automaticamente
  }

  Future<List<MoodEntry>> getAll() async {
    return _service.fetchEntries();
  }

  void dispose() {
    _firestoreSubscription?.cancel();
    _entriesController.close();
  }
}