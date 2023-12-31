import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_h2o/interfaces/i_notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

import '../db_models/reminder_model.dart';

class NotificationService implements INotificationService{
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

  Future<void> scheduleDailyNotification(Reminder reminder) async {
    // Convert triggerTime to a tz.TZDateTime object for scheduling
    final timeParts = reminder.getTriggerTime().split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If the scheduled time is in the past, schedule it for the next day
    final tz.TZDateTime firstOccurrence = scheduledTime.isBefore(now)
        ? scheduledTime.add(Duration(days: 1))
        : scheduledTime;

    // Define the notification details
    var androidDetails = AndroidNotificationDetails(
      'daily_notification_channel',
      'Daily Notifications',
      channelDescription: 'Channel for daily notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = DarwinNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule the notification to repeat daily
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.getId(),
      'Water Reminder',
      'Time to drink water!',
      firstOccurrence,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // To repeat daily at the same time
      payload: "Your sister a mister",
    );
  }

  // Schedule a notification
  @override
  Future<void> scheduleNotification(Reminder reminder) async {
    // Convert triggerTime to a DateTime object
    // Extract the current date
    final currentDate = DateTime.now();
    // Extract the hour and minute from the triggerTime
    final timeParts = reminder.getTriggerTime().split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Combine them into a DateTime object
    final scheduledTime = DateTime(currentDate.year, currentDate.month, currentDate.day, hour, minute);

    //final DateTime scheduledTime = DateTime.parse(reminder.getTriggerTime());
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    print('TriggerTime: $tzScheduledTime');


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
      payload: "hey boss!!!!"
    );
    var pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var notification in pendingNotifications) {
      print('Notification: id=${notification.id}, title=${notification.title}, body=${notification.body}, payload=${notification.payload}');
    }
  }

  Future<void> triggerNotificationNow(int notificationId) async {
    // Retrieve the details of the scheduled notification by its ID
    // This step depends on how you store your scheduled notifications

    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = DarwinNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);


    // Schedule the notification to trigger immediately
    await _flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    "Test",
    "Wabec lol haha",
    tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
platformDetails, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
    }

  // Handle notification response when the app is running
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle the notification response
  }

  // Handle notification response when the app is in the background
}

void _onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response) {
  print("Notification clicked with payload: ${response.payload}");
  // Handle the background notification response
}
