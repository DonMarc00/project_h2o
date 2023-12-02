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
    final database = openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE IF NOT EXISTS reminders (id INTEGER PRIMARY KEY, triggerTime TEXT)");
      },
      version: 1,
    );
    return database;
  }
}
