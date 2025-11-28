import 'package:flutter/material.dart'; // REMOVA O IMPORT DO FOUNDATION
import 'package:emotion_app/utils/command.dart';
import 'package:emotion_app/utils/result.dart';
import 'package:emotion_app/data/services/notification_service.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel() {
    loadSettings = Command<void, void>(_loadSettings);
    saveSettings = Command<void, void>(_saveSettings);
    saveNotificationTime = Command<void, TimeOfDay>(_saveNotificationTime);
    toggleNotifications = Command<void, bool>(_toggleNotifications);
    
    loadSettings.execute(null);
  }

  late Command<void, void> loadSettings;
  late Command<void, void> saveSettings;
  late Command<void, TimeOfDay> saveNotificationTime;
  late Command<void, bool> toggleNotifications;

  final NotificationService _notificationService = NotificationService();

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;
  
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay get notificationTime => _notificationTime;

  Future<Result<void>> _loadSettings(void _) async {
    try {
      await _notificationService.initialize();
      
      await _notificationService.requestNotificationPermission();
      
      if (_notificationsEnabled) {
        await _scheduleNotification();
      }
      
      return Ok(null);
    } catch (e) {
      return Error("Erro ao carregar configurações: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _saveSettings(void _) async {
    try {
      return Ok(null);
    } catch (e) {
      return Error("Erro ao salvar configurações: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _saveNotificationTime(TimeOfDay newTime) async {
    try {
      _notificationTime = newTime;
      
      if (_notificationsEnabled) {
        await _scheduleNotification();
      }
      
      return Ok(null);
    } catch (e) {
      return Error("Erro ao salvar horário: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _toggleNotifications(bool enabled) async {
    try {
      _notificationsEnabled = enabled;
      
      if (enabled) {
        await _scheduleNotification();
      } else {
        await _notificationService.cancelNotification(0);
      }
      
      return Ok(null);
    } catch (e) {
      return Error("Erro ao alterar notificações: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _scheduleNotification() async {
    try {
      await _notificationService.scheduleDailyNotification(
        time: _notificationTime,
        title: 'Como você está se sentindo?',
        body: 'Registre seu humor do dia para acompanhar seu bem-estar emocional.',
        id: 0,
      );
    } catch (e) {
      // REMOVA O PRINT E USE debugPrint
      debugPrint('Erro ao agendar notificação: $e');
    }
  }

  void setNotificationsEnabled(bool value) {
    toggleNotifications.execute(value);
  }

  void setNotificationTime(TimeOfDay time) {
    saveNotificationTime.execute(time);
  }
}