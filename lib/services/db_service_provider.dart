import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_service.dart';

class DBServiceProvider {
  static DBService? _instance;

  static Future<DBService> getInstance() async {
    if (_instance == null) {
      Database db = await openDatabaseConnection();
      _instance = DBService(db);
    }
    return _instance!;
  }

  static Future<Database> openDatabaseConnection({bool inMemory = false}) async{
    String dbPath = inMemory ? ':memory' : join(await getDatabasesPath(), 'reminder_database.db');
    String sqlCreate = "CREATE TABLE reminders (id INTEGER PRIMARY KEY AUTOINCREMENT, triggerTime TEXT)";
    if(dbPath.contains("memory")){
      sqlCreate = "CREATE TABLE reminders (id INTEGER PRIMARY KEY, triggerTime TEXT)";
    }
    final database = openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(sqlCreate);
      },
      version: 2,
    );
    return database;
  }
}
