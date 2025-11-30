// notifications_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:emotion_app/data/services/notificacao_service.dart';

class NotificationsViewModel with ChangeNotifier {
  final NotificationService _notificationsService = NotificationService();
  
  List<Map<String, dynamic>> _reminders = [];
  bool _isLoading = false;
  bool _notificationsEnabled = true;

  List<Map<String, dynamic>> get reminders => _reminders;
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;

  NotificationsViewModel() {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationsService.initialize();
      _reminders = _notificationsService.getReminders();
    } catch (error) {
      print('Erro ao carregar lembretes: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotification(int id, bool enabled) async {
    final reminderIndex = _reminders.indexWhere((r) => r['id'] == id);
    if (reminderIndex != -1) {
      _reminders[reminderIndex]['enabled'] = enabled;
      notifyListeners();

      await _notificationsService.updateReminderStatus(id, enabled);
    }
  }

  Future<void> toggleAllNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    
    for (final reminder in _reminders) {
      reminder['enabled'] = enabled;
      await _notificationsService.updateReminderStatus(
        reminder['id'] as int, 
        enabled
      );
    }
    
    notifyListeners();
  }

  Future<void> scheduleAllNotifications() async {
    await _notificationsService.scheduleAllNotifications();
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsService.cancelAllNotifications();
    for (final reminder in _reminders) {
      reminder['enabled'] = false;
    }
    _notificationsEnabled = false;
    notifyListeners();
  }

  String formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}