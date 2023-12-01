import 'package:intl/intl.dart';

class DateHelper {

  DateHelper._internal();

  static String formatDateTime(DateTime dateTime){
    return DateFormat('HH:mm:ss').format(dateTime);
  }
}