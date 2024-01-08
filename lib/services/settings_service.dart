import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  void setRequiredWaterAmount(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('requiredWaterAmount', amount);
  }

  Future<double> getRequiredWaterAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('requiredWaterAmount') ?? 0;
  }
}