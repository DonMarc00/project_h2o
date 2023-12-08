import 'dart:async';

import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/date_utils.dart';

class DBService {

  final Database db;

  DBService(this.db);

  Future<int> insertReminder(Reminder reminder) async {
    return await db.insert(
      "reminders",
      reminder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<int> updateReminder(int id, DateTime triggerTime) async {
    String time = DateHelper.formatDateTime(triggerTime);
    return await db.rawUpdate("UPDATE reminders SET triggerTime = ? WHERE id = ?", [time, id]);
  }

  Future<int> deleteReminder(id) async {
    return await db.rawDelete("DELETE FROM reminders WHERE id = ?", [id]);
  }

}