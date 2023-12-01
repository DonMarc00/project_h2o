import 'package:flutter_test/flutter_test.dart';
import 'package:project_h2o/utils/date_utils.dart';

void main(){
   test("Formats standard DateTime correctly", () {
     DateTime standardDateTime = DateTime(2023, 1, 1, 14, 30, 15);
     String result = DateHelper.formatDateTime(standardDateTime);
     expect(result, equals("14:30:15"));
   });

   test('Formats midnight correctly', () {
     DateTime midnightDateTime = DateTime(2021, 1, 1, 0, 0, 0);
     String result = DateHelper.formatDateTime(midnightDateTime);
     expect(result, equals('00:00:10'));
   });

   test('Formats late night time correctly', () {
     DateTime lateDateTime = DateTime(2021, 1, 1, 1, 45, 30);
     String result = DateHelper.formatDateTime(lateDateTime);
     expect(result, equals('01:45:30'));
   });
}