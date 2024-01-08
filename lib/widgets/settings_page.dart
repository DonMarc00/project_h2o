import 'package:flutter/material.dart';
import 'package:project_h2o/services/settings_service.dart';
import 'package:flutter/services.dart';

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

class _SettingsPageState extends State<SettingsPage>{
  TextEditingController weightController = TextEditingController();

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
            Text("Required Water Amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text("Enter your weight in kg to calculate the required water amount",
            ),
            SizedBox(height: 10,),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight in kg',
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () => {
                saveRequiredWaterAmount()
              },
              child: Text("Save"),
            ),
          ],
        ),

      ),
    );
    throw UnimplementedError();
  }

  void saveRequiredWaterAmount() {
    // FORMULA: 0.033 * weight in kg = required water amount in liters
    double amount = double.parse(weightController.text) * 0.033;
    SettingsService settingsService = SettingsService();
    settingsService.setRequiredWaterAmount(amount);
  }
}