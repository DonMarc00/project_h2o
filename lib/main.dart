import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:project_h2o/db_models/reminder_model.dart';
import 'package:project_h2o/services/db_service_provider.dart';
import 'package:project_h2o/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:project_h2o/services/notification_service.dart';

import 'services/db_service.dart';
import 'utils/date_utils.dart';
import 'package:project_h2o/widgets/reminder_widget.dart';
import 'package:project_h2o/widgets/reminder_page_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
  NotificationService notificationService = NotificationService();
  await notificationService.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
          home: ChangeNotifierProvider(
            create: (context) => ReminderState(),
            child: MyHomePage(),
          ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = ChangeNotifierProvider(
          create: (_) => ReminderState(),
          child: ReminderPage(),
        );
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.list), label: Text("Reminders"))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }

  void createReminder() async {
    DBService dbService = await DBServiceProvider.getInstance();
    List<Reminder> reminderList = await dbService.getAllReminders();
    int maxId = -1;
    for (Reminder reminder in reminderList) {
      if (reminder.id > maxId) {
        maxId = reminder.id;
      }
    }
    if (maxId == -1) return;
    //Increment by 1 to add new reminder
    maxId++;
    // Check if the widget is still in the tree and has a valid context
    if (!mounted) return;
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String reminderTime = DateHelper.formatDateTime(
        DateHelper.convertTimeOfDayToDateTime(selectedTime!));
    Reminder reminder = Reminder(id: maxId, triggerTime: reminderTime);
    int i = await dbService.insertReminder(reminder);
    if (!mounted) return;
    if (i > 0) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder added successfully'), backgroundColor: Colors.green),
      );
    }
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  appState.toggleFavorite();
                  DBService dbservice = await DBServiceProvider.getInstance();
                  print(await dbservice.getAllReminders());
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  appState.getNext();
                  DBService dbservice = await DBServiceProvider.getInstance();
                  Reminder reminder = Reminder(
                      id: 1,
                      triggerTime: DateHelper.formatDateTime(
                          DateTime(0, 0, 0, 1, 8, 1)));
                  Reminder reminder2 = Reminder(
                      id: 2,
                      triggerTime: DateHelper.formatDateTime(
                          DateTime(3, 4, 5, 20, 20, 20)));
                  Reminder reminder3 = Reminder(
                      id: 4,
                      triggerTime: DateHelper.formatDateTime(
                          DateTime(3, 4, 5, 20, 20, 20)));
                  Reminder reminder4 = Reminder(
                      id: 3,
                      triggerTime: DateHelper.formatDateTime(
                          DateTime(3, 4, 5, 20, 20, 20)));
                  dbservice.insertReminder(reminder);
                  dbservice.insertReminder(reminder2);
                  dbservice.insertReminder(reminder3);
                  dbservice.insertReminder(reminder4);
                  print(await dbservice.getAllReminders());
                  print(await dbservice.getReminderById(3));
                  dbservice.updateReminder(2, DateTime(0, 0, 0, 23, 50, 50));
                  dbservice.deleteReminder(1);
                  print(await dbservice.getAllReminders());
                },
                child: Text('Next'),
              ),
            ],
          ),
          Row(
            children: [
              ReminderWidget(Reminder(
                  id: 1,
                  triggerTime:
                      DateHelper.formatDateTime(DateTime(0, 0, 0, 1, 1, 1)))),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}
