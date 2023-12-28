import '../db_models/reminder_model.dart';

abstract class INotificationService {
  Future<void> scheduleNotification(Reminder reminder);
}
