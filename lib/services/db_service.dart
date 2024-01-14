import 'dart:async';

import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/date_utils.dart';

class DBService {

  final Database db;

  DBService(this.db);

  Future<int> insertReminder(Reminder reminder) async {
    // Check if a reminder with the same trigger time already exists
    bool exists = await reminderExists(reminder.triggerTime);
    if (exists) {
      // If it exists, do not insert and perhaps return a specific code or throw an exception
      return -1; // or throw an exception
    } else {
      // If it does not exist, insert the new reminder
      return await db.insert(
        "reminders",
        reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<bool> reminderExists(String triggerTime) async {
    List<Map> maps = await db.query(
      "reminders",
      where: "triggerTime = ?",
      whereArgs: [triggerTime],
    );
    return maps.isNotEmpty;
  }

  Future<List<Reminder>> getAllReminders() async {
    final List<Map<String, dynamic>> maps = await db.query("reminders");

    return List.generate(maps.length, (i) {
      return Reminder(
        id: maps[i]['id'] as int,
        triggerTime: maps[i]['triggerTime'] as String,
      );
    });
  }

  Future<Map<String, dynamic>?> getReminderById(int id) async {
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM reminders WHERE id = ?", [id]);
    if(result.isNotEmpty){
      return result.first;
    } else {
      return null;
    }
  }

  //This function gets the highest id in the database and returns it + 1
  Future<int> getNextReminderId() async {
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT MAX(id) FROM reminders");
    if(result.isNotEmpty && result.first.values.first != null){
      return result.first.values.first + 1;
    } else {
      return 0;
    }
  }

  Future<int> updateReminder(int id, DateTime triggerTime) async {
    String time = DateHelper.formatDateTime(triggerTime);
    return await db.rawUpdate("UPDATE reminders SET triggerTime = ? WHERE id = ?", [time, id]);
  }

  Future<int> deleteReminder(id) async {
    return await db.rawDelete("DELETE FROM reminders WHERE id = ?", [id]);
  }

}