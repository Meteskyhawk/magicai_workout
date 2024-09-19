import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';

class WorkoutViewModel extends ChangeNotifier {
  Workout? _workout;

  Workout? get workout => _workout;

  void setWorkout(Workout? workout) {
    _workout = workout;
    notifyListeners();
  }

  void addSet(WorkoutSet set) {
    _workout?.sets.add(set);
    notifyListeners();
  }

  void updateSet(int index, WorkoutSet updatedSet) {
    if (_workout != null && index >= 0 && index < _workout!.sets.length) {
      _workout!.sets[index] = updatedSet;
      notifyListeners();
    }
  }

  void removeSet(int index) {
    _workout?.sets.removeAt(index);
    notifyListeners();
  }
}