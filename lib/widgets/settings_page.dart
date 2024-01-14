import 'package:flutter/material.dart';
import 'package:project_h2o/services/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';

class SettingsState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController weightController = TextEditingController();
  late DateTime? beginningOfDrinkDay;
  late DateTime? endOfDrinkDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Required Water Amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Enter your weight in kg to calculate the required water amount",
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight in kg',
                suffixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
                labelText: 'Beginning of drink day',
              ),
              mode: DateTimeFieldPickerMode.time,
              autovalidateMode: AutovalidateMode.always,
              validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onChanged: (DateTime? value) { beginningOfDrinkDay = value; },
            ),
            SizedBox(
              height: 10,
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
                labelText: 'End of drink day',
              ),
              mode: DateTimeFieldPickerMode.time,
              autovalidateMode: AutovalidateMode.always,
              validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onChanged: (DateTime? value) {
                endOfDrinkDay = value;
              },
            ),
            ElevatedButton(
              onPressed: saveData,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void saveRequiredWaterAmount() {
    // FORMULA: 0.033 * weight in kg = required water amount in liters
    double amount = double.parse(weightController.text) * 0.033;
    SettingsService settingsService = SettingsService();
    settingsService.setRequiredWaterAmount(amount);
  }

  void saveDrinkDay() {
    SettingsService settingsService = SettingsService();
    settingsService.setDrinkDay(beginningOfDrinkDay!, endOfDrinkDay!);
  }

  void saveData() {
    saveRequiredWaterAmount();
    saveDrinkDay();
  }
}
