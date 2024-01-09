import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_h2o/utils/date_utils.dart';

class SettingsService {

  void setRequiredWaterAmount(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('requiredWaterAmount', amount);
  }

  Future<double> getRequiredWaterAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('requiredWaterAmount') ?? 0;
  }

  void setDrinkDay(DateTime beginningOfDrinkDay, DateTime endOfDrinkDay) {
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      value.setString('beginningOfDrinkDay', DateHelper.formatDateTime(beginningOfDrinkDay));
      value.setString('endOfDrinkDay', DateHelper.formatDateTime(endOfDrinkDay));
    });
  }
}