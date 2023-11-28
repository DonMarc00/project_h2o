import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static DBService? _instance;
  Database? db;

  DBService._(this.db);

  static Future<DBService> getInstance() async {
    if (_instance == null) {
      var db = await openDatabaseConnection();
      _instance = DBService._(db);
    }
    return _instance!;
  }

  static Future<Database> openDatabaseConnection() async{
    final database = openDatabase(
      join(await getDatabasesPath(), "reminder_database.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE reminders (id INTEGER PRIMARY KEY, triggerTime TEXT)");
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertReminder(Reminder reminder) async {
    await db!.insert(
      "reminders",
      reminder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Reminder>> getAllReminders() async {
    final List<Map<String, dynamic>> maps = await db!.query("reminders");

    return List.generate(maps.length, (i) {
      return Reminder(
        id: maps[i]['id'] as int,
        triggerTime: maps[i]['triggerTime'] as String,
      );
    });
  }

}
