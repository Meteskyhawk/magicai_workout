import 'package:flutter/foundation.dart';
import '../../models/workout.dart';
import '../../services/storage_service.dart';

class WorkoutListViewModel extends ChangeNotifier {
  final StorageService _storageService;
  List<Workout> _workouts = [];

  WorkoutListViewModel({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  List<Workout> get workouts => _workouts;

  Map<String, dynamic> get weeklyStats {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    int workouts = 0;
    int sets = 0;
    double weight = 0.0;

    for (var workout in _workouts) {
      if (workout.date.isAfter(startOfWeek)) {
        workouts++;
        for (var set in workout.sets) {
          sets++;
          weight += set.weight * set.repetitions;
        }
      }
    }

    return {
      'workouts': workouts,
      'sets': sets,
      'weight': weight,
    };
  }

  Future<void> loadWorkouts() async {
    _workouts = await _storageService.getWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    _workouts.add(workout);
    await _storageService.saveWorkouts(_workouts);
    notifyListeners();
  }

  Future<void> updateWorkout(Workout updatedWorkout) async {
    final index =
        _workouts.indexWhere((workout) => workout.id == updatedWorkout.id);
    if (index != -1) {
      _workouts[index] = updatedWorkout;
      await _storageService.saveWorkouts(_workouts);
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((workout) => workout.id == id);
    await _storageService.saveWorkouts(_workouts);
    notifyListeners();
  }
}
