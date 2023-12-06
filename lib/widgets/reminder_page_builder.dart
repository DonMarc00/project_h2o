import 'package:flutter/material.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/main.dart';
import 'package:project_h2o/services/db_service.dart';
import 'package:project_h2o/services/db_service_provider.dart';
import 'package:project_h2o/widgets/reminder_widget.dart';

class ReminderState extends ChangeNotifier{
  List<Reminder> reminderList = [];
  List<Widget> widgetList = [];

  Future<void> getReminders() async {
    final dbservice = await DBServiceProvider.getInstance();
    reminderList = await dbservice.getAllReminders();
    widgetList.clear();
    for (Reminder reminder in reminderList) {
      widgetList.add(ReminderWidget(reminder));
    }
    notifyListeners();
  }
}

class ReminderPage extends StatefulWidget {
  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late ReminderState appState;

  @override
  void initState() {
    super.initState();
    appState = ReminderState();
    appState.getReminders().then((_) {
      setState(() {}); // Rebuild the widget after reminders are fetched.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appState.widgetList,
    );
  }
}
