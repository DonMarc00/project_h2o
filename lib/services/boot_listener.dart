import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:project_h2o/services/notification_service.dart';

Future<void> setupBootListener() async {
  NotificationService notificationService = NotificationService();
  await AndroidAlarmManager.initialize();

  // Set the delay to a minimum value as we only need to trigger the callback
  await AndroidAlarmManager.oneShot(
    Duration(seconds: 1), // Minimal delay
    0, // Unique identifier for the alarm
    notificationService.rescheduleNotifications,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}
