import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emotion_app/data/services/notification_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;
  
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay get notificationTime => _notificationTime;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    final hour = prefs.getInt('notification_hour') ?? 9;
    final minute = prefs.getInt('notification_minute') ?? 0;
    _notificationTime = TimeOfDay(hour: hour, minute: minute);
    
    await _notificationService.initialize();
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setInt('notification_hour', _notificationTime.hour);
    await prefs.setInt('notification_minute', _notificationTime.minute);

    if (_notificationsEnabled) {
      await _notificationService.sendNotification(
        'Configurações Salvas ✅',
        'Lembretes ativos para ${_formatTime(_notificationTime)}',
      );
    }
    
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    saveSettings();
  }

  void setNotificationTime(TimeOfDay time) {
    _notificationTime = time;
    saveSettings();
  }

  Future<void> testNotification() async {
    await _notificationService.sendNotification(
      'Teste de Notificação',
      'Notificações funcionando! 🎉',
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '$displayHour:$minute $period';
  }
}