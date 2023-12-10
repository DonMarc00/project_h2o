import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_h2o/services/db_service.dart';
import 'package:project_h2o/services/db_service_provider.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/widgets/reminder_page_builder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DBService dbService;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    Database db = await DBServiceProvider.openDatabaseConnection(inMemory: true);
    dbService = DBService(db);
  });

  tearDown(() async {
    await dbService.db.close();
  });

  group('ReminderState', () {
    test('addReminder adds a reminder', () async {
      var reminderState = ReminderState();
      var reminder = Reminder(id: 1, triggerTime: "10:00 AM");
      await reminderState.addReminder(reminder);
      expect(reminderState.reminderList.contains(reminder), true);
    });

    test('deleteReminder removes a reminder', () async {
      var reminderState = ReminderState();
      var reminder = Reminder(id: 1, triggerTime: "10:00 AM");
      reminderState.reminderList.add(reminder);
      await reminderState.deleteReminder(1);
      expect(reminderState.reminderList.contains(reminder), false);
    });

    test('getReminders fetches reminders', () async {
      var reminderState = ReminderState();
      var testReminder = Reminder(id: 1, triggerTime: "10:00 AM");
      await reminderState.addReminder(testReminder);
      var testReminder2 = Reminder(id: 2, triggerTime: "11:00 AM");
      await reminderState.addReminder(testReminder2);
      await reminderState.getReminders();
      expect(reminderState.reminderList.isNotEmpty, true);
      expect(reminderState.reminderList[0].getId(), testReminder.getId());
      expect(reminderState.reminderList[0].getTriggerTime(), testReminder.getTriggerTime());
      expect(reminderState.reminderList[1].getId(), testReminder2.getId());
      expect(reminderState.reminderList[1].getTriggerTime(), testReminder2.getTriggerTime());
    });

  });
}
