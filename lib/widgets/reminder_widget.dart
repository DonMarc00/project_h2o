import 'package:flutter/material.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/widgets/reminder_page_builder.dart';
import 'package:provider/provider.dart';

class ReminderWidget extends StatelessWidget {

  late final Reminder reminder;
  
  ReminderWidget(this.reminder);

  @override
  Widget build(BuildContext context) {
    final reminderState = Provider.of<ReminderState>(context, listen: false);

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.blueAccent, spreadRadius: 3)]),

      child: Column(
        children: [
          Text("ID: ${reminder.id}",
          textScaler: TextScaler.linear(1.3),),
          Text("Time: ${reminder.triggerTime}",
            textScaler: TextScaler.linear(1.3),),
          ElevatedButton.icon(onPressed: () => {
            reminderState.deleteReminder(reminder.id)
          }, icon: Icon(Icons.delete),
          label: Text("Delete"),
          )
        ],
      ),
    );
  }

  Reminder getReminder() {
    return reminder;
  }
}
