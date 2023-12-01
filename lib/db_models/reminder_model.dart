import 'package:intl/intl.dart';

class Reminder {
  final int id;
  final String triggerTime;

  Reminder({
    required this.id,
    required this.triggerTime,
  });

  Map<String, dynamic> toMap(){
    return {
      "id":id,
      "triggerTime":triggerTime,
    };
  }

  @override
  String toString(){
    return "Reminder{id: $id, triggerTime: $triggerTime}";
  }
}
