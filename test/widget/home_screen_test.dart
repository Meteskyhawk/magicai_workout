import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_tracker/features/home/home_screen.dart';
import 'package:magic_tracker/features/workout/workout_list_screen.dart';
import 'package:magic_tracker/features/workout/workout_list_viewmodel.dart';
import 'package:provider/provider.dart';

// Import the models
import 'package:magic_tracker/models/workout.dart';
import 'package:magic_tracker/models/workout_set.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    // Provide the necessary WorkoutListViewModel
    final workoutListViewModel = WorkoutListViewModel();

    // Build the HomeScreen widget with provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WorkoutListViewModel>.value(
            value: workoutListViewModel,
          ),
        ],
        child: MaterialApp(
          home: const HomeScreen(),
        ),
      ),
    );

    // Verify that the main text and buttons are displayed
    expect(find.text('Magic AI Workout!'), findsOneWidget);
    expect(find.text('PLANNING'), findsOneWidget);
    expect(find.text('WORKOUTS'),
        findsWidgets); // Use findsWidgets because there might be more than one
  });

  testWidgets('HomeScreen navigates to WorkoutListScreen on tap',
      (WidgetTester tester) async {
    // Provide the necessary WorkoutListViewModel
    final workoutListViewModel = WorkoutListViewModel();

    // Build the HomeScreen widget with provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WorkoutListViewModel>.value(
            value: workoutListViewModel,
          ),
        ],
        child: MaterialApp(
          home: const HomeScreen(),
        ),
      ),
    );

    // Allow the widget tree to build
    await tester.pump();

    // Tap the 'WORKOUTS' button using the text
    await tester.tap(find.text('WORKOUTS'));

    // Allow any asynchronous operations (like navigation) to complete
    await tester.pumpAndSettle();

    // Verify that we navigated to the WorkoutListScreen
    expect(find.byType(WorkoutListScreen), findsOneWidget);
  });

  testWidgets('HomeScreen shows workout summary correctly',
      (WidgetTester tester) async {
    // Provide the necessary WorkoutListViewModel with some data
    final workoutListViewModel = WorkoutListViewModel();
    workoutListViewModel.addWorkout(
      Workout(
        id: '1',
        date: DateTime.now(),
        sets: [WorkoutSet(exercise: 'Squat', weight: 100, repetitions: 5)],
      ),
    );

    // Build the HomeScreen widget with provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WorkoutListViewModel>.value(
            value: workoutListViewModel,
          ),
        ],
        child: MaterialApp(
          home: const HomeScreen(),
        ),
      ),
    );

    // Allow the widget tree to build
    await tester.pump();

    // Verify that the workout summary displays correct data
    expect(find.text('Workouts'),
        findsWidgets); // Use findsWidgets since 'Workouts' appears multiple times
    expect(
        find.text('1'), findsWidgets); // Match occurrences in summary and list
    expect(find.text('Total Sets'), findsOneWidget);
    expect(find.text('Total Weight'), findsOneWidget);
    expect(find.text('500.0 kg'), findsOneWidget); // 100 weight * 5 repetitions
  });
}
