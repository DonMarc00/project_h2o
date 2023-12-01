import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_h2o/services/db_service.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/utils/date_utils.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('DBService Tests', () {
    late MockDatabase mockDatabase;
    late DBService dbService;

    setUp(() {
      mockDatabase = MockDatabase();
      dbService = DBService(mockDatabase);
    });
  });
}
