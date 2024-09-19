import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class StorageService {
  static const String _workoutsKey = 'workouts';

  Future<List<Workout>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = prefs.getString(_workoutsKey);
    if (workoutsJson != null) {
      final workoutsList = jsonDecode(workoutsJson) as List;
      return workoutsList.map((workout) => Workout.fromJson(workout)).toList();
    }
    return [];
  }

  Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = jsonEncode(workouts.map((workout) => workout.toJson()).toList());
    await prefs.setString(_workoutsKey, workoutsJson);
  }
}