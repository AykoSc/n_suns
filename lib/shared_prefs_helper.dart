import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  Future<int> loadWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('week') ?? 0;
  }

  Future<String> loadWorkoutName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('workoutName') ?? "Bench Press / OHP";
  }
}