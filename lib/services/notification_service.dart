import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../db_models/reminder_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the notification settings
  Future<void> initNotifications() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      // Add other platform-specific settings if needed
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse,
    );
  }

  // Schedule a notification
  Future<void> scheduleNotification(Reminder reminder) async {
    // Convert triggerTime to a DateTime object
    final DateTime scheduledTime = DateTime.parse(reminder.getTriggerTime());
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);


    // Define the notification details
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = DarwinNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.getId(),
      'Water Reminder',
      'Time to drink water!',
      tzScheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // To repeat daily at the same time
    );
  }

  // Handle notification response when the app is running
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle the notification response
  }

  // Handle notification response when the app is in the background
  void _onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
    // Handle the background notification response
  }
}
