// notification_service.dart (versão simplificada)
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Map<String, dynamic>> reminders = [
    {
      'id': 0,
      'hour': 8,
      'minute': 0,
      'title': 'Bom dia!',
      'body': 'Hora de começar o dia com um copo d\'água💧',
      'enabled': true,
    },
    {
      'id': 1,
      'hour': 10,
      'minute': 0,
      'title': 'Movimente-se!',
      'body': 'Lembre-se de fazer um alongamento🏃',
      'enabled': true,
    },
    {
      'id': 2,
      'hour': 11,
      'minute': 30,
      'title': 'Alimente-se!',
      'body': 'Lembre-se de fazer uma alimentação saudável😋',
      'enabled': true,
    },
    {
      'id': 3,
      'hour': 14,
      'minute': 0,
      'title': 'Hora de se hidratar!',
      'body': 'Não esqueça de beber água💧',
      'enabled': true,
    },
    {
      'id': 4,
      'hour': 18,
      'minute': 0,
      'title': 'Exercício físico',
      'body': 'Que tal uma caminhada para encerrar o dia?💪',
      'enabled': true,
    },
    {
      'id': 5,
      'hour': 22,
      'minute': 0,
      'title': 'Sono saudável',
      'body': 'Uma boa noite de sono ajuda na saúde.😴',
      'enabled': true,
    },
  ];

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Log para debug - remova em produção
      },
    );

    _isInitialized = true;
  }

  Future<void> scheduleAllNotifications() async {
    await cancelAllNotifications();
    
    for (final reminder in reminders) {
      if (reminder['enabled'] == true) {
        await _scheduleReminder(reminder);
      }
    }
  }

  Future<void> _scheduleReminder(Map<String, dynamic> reminder) async {
    final scheduledDate = _nextInstanceOfTime(
      reminder['hour'] as int,
      reminder['minute'] as int,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder['id'] as int,
      reminder['title'] as String,
      reminder['body'] as String,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders_channel',
          'Lembretes Diários',
          channelDescription: 'Lembretes de saúde ao longo do dia',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> updateReminderStatus(int id, bool enabled) async {
    final reminderIndex = reminders.indexWhere((r) => r['id'] == id);
    if (reminderIndex != -1) {
      reminders[reminderIndex]['enabled'] = enabled;
      
      if (enabled) {
        await _scheduleReminder(reminders[reminderIndex]);
      } else {
        await cancelNotification(id);
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  List<Map<String, dynamic>> getReminders() {
    return List.from(reminders);
  }
}