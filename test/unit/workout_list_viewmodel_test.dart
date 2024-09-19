import 'package:flutter_test/flutter_test.dart';
import 'package:magic_tracker/features/workout/workout_list_viewmodel.dart';
import 'package:magic_tracker/models/workout.dart';
import 'package:magic_tracker/models/workout_set.dart';
import 'package:mockito/mockito.dart';
import 'mock_storage_service.mocks.dart'; // Import the generated mocks file

void main() {
  group('WorkoutListViewModel', () {
    late WorkoutListViewModel viewModel;
    late MockStorageService mockStorageService;

    setUp(() {
      mockStorageService = MockStorageService();
      viewModel = WorkoutListViewModel(storageService: mockStorageService);
      when(mockStorageService.getWorkouts()).thenAnswer((_) async => []);
    });

    test('addWorkout should add a workout to the list', () async {
      final workout = Workout(
        id: '1',
        sets: [WorkoutSet(exercise: 'Squat', weight: 100, repetitions: 5)],
        date: DateTime.now(),
      );

      when(mockStorageService.saveWorkouts(any)).thenAnswer((_) async {
        return null;
      });

      await viewModel.addWorkout(workout);

      expect(viewModel.workouts.length, 1);
      expect(viewModel.workouts.first.id, '1');
      expect(viewModel.workouts.first.sets.first.exercise, 'Squat');
      verify(mockStorageService.saveWorkouts(any)).called(1);
    });

    test('weeklyStats should calculate correct stats', () async {
      final now = DateTime.now();
      final workout1 = Workout(
        id: '1',
        sets: [
          WorkoutSet(exercise: 'Squat', weight: 100, repetitions: 5),
          WorkoutSet(exercise: 'Bench Press', weight: 80, repetitions: 5),
        ],
        date: now,
      );
      final workout2 = Workout(
        id: '2',
        sets: [
          WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5),
        ],
        date: now.subtract(const Duration(days: 1)),
      );

      when(mockStorageService.saveWorkouts(any)).thenAnswer((_) async {});

      await viewModel.addWorkout(workout1);
      await viewModel.addWorkout(workout2);

      final stats = viewModel.weeklyStats;

      expect(stats['workouts'], 2);
      expect(stats['sets'], 3);
      expect(stats['weight'], 1500.0);
    });

    test('deleteWorkout should remove a workout from the list', () async {
      final workout = Workout(
        id: '1',
        sets: [WorkoutSet(exercise: 'Squat', weight: 100, repetitions: 5)],
        date: DateTime.now(),
      );

      await viewModel.addWorkout(workout);
      expect(viewModel.workouts.length, 1);

      await viewModel.deleteWorkout('1');
      expect(viewModel.workouts.length, 0);
    });

    test('updateWorkout should modify an existing workout', () async {
      final originalWorkout = Workout(
        id: '1',
        sets: [WorkoutSet(exercise: 'Squat', weight: 100, repetitions: 5)],
        date: DateTime.now(),
      );

      await viewModel.addWorkout(originalWorkout);

      final updatedWorkout = Workout(
        id: '1',
        sets: [WorkoutSet(exercise: 'Bench Press', weight: 80, repetitions: 8)],
        date: DateTime.now(),
      );

      await viewModel.updateWorkout(updatedWorkout);

      expect(viewModel.workouts.length, 1);
      expect(viewModel.workouts.first.sets.first.exercise, 'Bench Press');
      expect(viewModel.workouts.first.sets.first.weight, 80);
      expect(viewModel.workouts.first.sets.first.repetitions, 8);
    });
  });
}
