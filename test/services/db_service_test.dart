import 'package:flutter_test/flutter_test.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/services/db_service.dart';
import 'package:project_h2o/services/db_service_provider.dart';
import 'package:project_h2o/utils/date_utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DBService dbService;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    databaseFactory = databaseFactoryFfi;

    // Initialize the in-memory database
    Database db = await DBServiceProvider.openDatabaseConnection(inMemory: true);
    dbService = DBService(db);
  });

  tearDown(() async {
    await dbService.db.close();
  });

  test('Get Reminder By ID Test', () async {
    Reminder testReminder = Reminder(id: 1, triggerTime: '2023-01-01 10:00:00');
    await dbService.insertReminder(testReminder);

    var reminder = await dbService.getReminderById(1);

    expect(reminder, isNotNull);
    expect(reminder?['id'], testReminder.id);
    expect(reminder?['triggerTime'], testReminder.triggerTime);
  });


  test('Insert Reminder Test', () async {
    Reminder testReminder = Reminder(id: 1, triggerTime: '2023-01-01 10:00:00');

    int result = await dbService.insertReminder(testReminder);

    expect(result, 1);

    final insertedReminder = await dbService.getReminderById(1);
    expect(insertedReminder, isNotNull);
    expect(insertedReminder?['id'], testReminder.id);
    expect(insertedReminder?['triggerTime'], testReminder.triggerTime);
  });

  test('Get All Reminders Test', () async {
    Reminder testReminder1 = Reminder(id: 1, triggerTime: '2023-01-01 10:00:00');
    Reminder testReminder2 = Reminder(id: 2, triggerTime: '2023-01-02 10:00:00');
    await dbService.insertReminder(testReminder1);
    await dbService.insertReminder(testReminder2);

    List<Reminder> reminders = await dbService.getAllReminders();

    expect(reminders.length, 2);
    expect(reminders[0].id, testReminder1.id);
    expect(reminders[1].id, testReminder2.id);
  });

  test('Update Reminder Test', () async {
    Reminder testReminder = Reminder(id: 1, triggerTime: '2023-01-01 10:00:00');
    await dbService.insertReminder(testReminder);
    DateTime newTime = DateTime(2023, 01, 02, 10, 00, 00);

    int result = await dbService.updateReminder(1, newTime);
    var updatedReminder = await dbService.getReminderById(1);

    expect(result, 1);
    expect(updatedReminder?['triggerTime'], DateHelper.formatDateTime(newTime));
  });

  test('Delete Reminder Test', () async {
    Reminder testReminder = Reminder(id: 1, triggerTime: '2023-01-01 10:00:00');
    await dbService.insertReminder(testReminder);

    int result = await dbService.deleteReminder(1);
    var deletedReminder = await dbService.getReminderById(1);

    expect(result, 1);
    expect(deletedReminder, isNull);
  });

}
