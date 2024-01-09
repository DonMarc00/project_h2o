import 'package:flutter/material.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/services/db_service_provider.dart';
import 'package:project_h2o/widgets/reminder_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../interfaces/i_notification_service.dart';
import '../utils/date_utils.dart';
import 'package:project_h2o/services/notification_service.dart';

class ReminderState extends ChangeNotifier {
  List<Reminder> reminderList = [];
  List<ReminderWidget> widgetList = [];

  final INotificationService notificationService = NotificationService();

  Future<void> getReminders() async {
    final dbservice = await DBServiceProvider.getInstance();
    reminderList = await dbservice.getAllReminders();
    widgetList.clear();
    for (Reminder reminder in reminderList) {
      widgetList.add(ReminderWidget(reminder));
    }
    print("get reminders called");
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    final dbService = await DBServiceProvider.getInstance();
    int result = await dbService.insertReminder(reminder);

    if (result > 0) {
      reminderList.add(reminder);
      widgetList.add(ReminderWidget(reminder));
      await notificationService.scheduleDailyNotification(reminder);
      notifyListeners();
    }
  }

  Future<void> deleteReminder(int id) async {
    final dbService = await DBServiceProvider.getInstance();
    dbService.deleteReminder(id);
    reminderList.removeWhere((reminder) => reminder.getId() == id);
    widgetList.removeWhere(
        (reminderWidget) => reminderWidget.getReminder().getId() == id);
    notifyListeners();
    print("Deleted reminder");
  }

  int getNextReminderId() {
    return reminderList.fold(-1, (max, r) => r.id > max ? r.id : max) + 1;
  }
}

class ReminderPage extends StatefulWidget {
  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late ReminderState appState;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initAppState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ReminderState>(builder: (context, appState, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Reminders"),
              ),
              body: ListView.builder(
                itemCount: appState.reminderList.length,
                itemBuilder: (context, index) {
                  return ReminderWidget(appState.reminderList[index]);
                },
              ),
              floatingActionButtonLocation: ExpandableFab.location,
              floatingActionButton: ExpandableFab(
                children: [
                  FloatingActionButton(
                      onPressed: () => {createReminderEntry()},
                      child: Icon(Icons.add)),
                  FloatingActionButton(
                      onPressed: () => {appState.getReminders()},
                      child: Icon(Icons.access_time)),
                  FloatingActionButton(
                      onPressed: () => {appState.getReminders()},
                      child: Icon(Icons.refresh)),
                ],
              ),
            );
          });
        } else {
          return CircularProgressIndicator(); // or some other loading indicator
        }
      },
    );
  }

  Future<void> _initAppState() async {
    appState = Provider.of<ReminderState>(context, listen: false);
    await appState.getReminders();
  }

  void createReminderEntry() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String reminderTime = DateHelper.formatDateTime(
          DateHelper.convertTimeOfDayToDateTime(selectedTime));

      int newId = appState.getNextReminderId();
      Reminder newReminder = Reminder(id: newId, triggerTime: reminderTime);

      await appState.addReminder(newReminder);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Reminder added successfully'),
            backgroundColor: Colors.green),
      );
    }
  }
}
