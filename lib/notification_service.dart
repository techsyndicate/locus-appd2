import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

  factory NotificationService() {
    return _notificationService;
  }

  Future<void> init() async {
    final AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('remediid', 'remedi', 'notifications for remedi', importance: Importance.high, priority: Priority.high, ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, 'title', 'body', notificationDetails);
  }

  Future<void> scheduleNotification(String name, DateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(0, name, 'Reminder to take ' + name + '!', tz.TZDateTime.from(dateTime, tz.local), NotificationDetails(android: AndroidNotificationDetails('remediid', 'remedi', 'notifications for remedi', importance: Importance.high, priority: Priority.high, ticker: 'ticker')), uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true);
  }

  NotificationService._internal();

}