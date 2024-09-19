import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
        'tap on WORKOUTS, add a new workout, and verify it appears in the list',
        (tester) async {
      try {
        app.main();
        await tester.pumpAndSettle();

        // Verify that we are on the HomeScreen
        expect(find.text('Magic AI Workout!'), findsOneWidget);
        print('Found HomeScreen');

        // Scroll to make sure the WORKOUTS button is visible
        await tester.drag(
            find.byType(SingleChildScrollView), const Offset(0, -200));
        await tester.pumpAndSettle();

        // Tap on the WORKOUTS button using the key
        await tester.tap(find.byKey(const Key('workoutsButton')));
        await tester.pumpAndSettle();
        print('Tapped WORKOUTS button');

        // Verify that we are on the WorkoutListScreen
        expect(find.text('Workouts'), findsOneWidget);
        print('Found WorkoutListScreen');

        // Tap on the add workout button (make sure the add button has a unique key)
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        print('Tapped add workout button');

        // Verify that the add workout dialog is shown
        expect(find.text('Add New Workout'), findsOneWidget);
        print('Found Add New Workout dialog');

        // Fill in the workout details
        await tester.enterText(find.byType(TextFormField).at(0), 'Squat');
        await tester.enterText(find.byType(TextFormField).at(1), '100');
        await tester.enterText(find.byType(TextFormField).at(2), '5');
        print('Entered workout details');

        // Save the workout
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        print('Tapped Save button');

        // Verify that the new workout appears in the list
        expect(find.text('Squat'), findsOneWidget);
        expect(find.text('100 kg, 5 reps'), findsOneWidget);
        print('Verified new workout in list');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });
  });
}
