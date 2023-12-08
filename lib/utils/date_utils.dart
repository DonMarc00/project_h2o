import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {

  DateHelper._internal();

  static String formatDateTime(DateTime dateTime){
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay){
    final now = DateTime.now();
    return DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute,0);
  }
}