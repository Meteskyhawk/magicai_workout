import 'package:flutter/material.dart';
import 'package:magic_tracker/features/home/home_screen.dart';
import 'package:magic_tracker/features/workout/workout_list_screen.dart';
import 'package:provider/provider.dart';
import '../workout/workout_list_viewmodel.dart';
import '../../models/workout.dart';

class WeeklySummaryScreen extends StatelessWidget {
  const WeeklySummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Weekly Summary',
            style: TextStyle(color: Colors.purple)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Consumer<WorkoutListViewModel>(
          builder: (context, viewModel, child) {
            final weeklyWorkouts = viewModel.workouts.where((workout) {
              final now = DateTime.now();
              final weekStart = now.subtract(Duration(days: now.weekday - 1));
              return workout.date.isAfter(weekStart) &&
                  workout.date.isBefore(now);
            }).toList();
            return ListView.builder(
              itemCount: weeklyWorkouts.length,
              itemBuilder: (context, index) {
                final workout = weeklyWorkouts[index];
                return _buildWorkoutCard(workout);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout on ${workout.date.toString().split(' ')[0]}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            ...workout.sets.map((set) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                      '${set.exercise}: ${set.weight} kg x ${set.repetitions} reps'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), label: 'Workouts'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.blue,
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutListScreen()),
          );
        }
      },
    );
  }
}
