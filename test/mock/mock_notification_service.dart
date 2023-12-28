import 'package:mockito/mockito.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/interfaces/i_notification_service.dart';

class MockNotificationService extends Mock implements INotificationService {
  @override
  Future<void> scheduleNotification(Reminder reminder) async{
  }
}