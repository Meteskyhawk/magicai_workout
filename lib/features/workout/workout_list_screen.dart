import 'package:flutter/material.dart';
import 'package:magic_tracker/features/home/home_screen.dart';
import 'package:magic_tracker/features/workout/workout_list_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../models/workout.dart';
import '../../../models/workout_set.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Workouts', style: TextStyle(color: Colors.purple)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Consumer<WorkoutListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.workouts.isEmpty) {
              return const Center(
                  child: Text('No workouts yet',
                      style: TextStyle(color: Colors.blue)));
            }
            return ListView.builder(
              itemCount: viewModel.workouts.length,
              itemBuilder: (context, index) {
                final workout = viewModel.workouts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Workout ${index + 1}',
                        style: const TextStyle(color: Colors.purple)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: workout.sets
                          .map((set) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(set.exercise,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                    Text(
                                        '${set.weight} kg, ${set.repetitions} reps',
                                        style: const TextStyle(
                                            color: Colors.blue)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    onTap: () => _showWorkoutDialog(context, workout),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.purple),
                      onPressed: () => Provider.of<WorkoutListViewModel>(
                              context,
                              listen: false)
                          .deleteWorkout(workout.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewWorkout(context),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _showWorkoutDialog(BuildContext context, Workout workout,
      {bool isNew = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isNew ? 'Add New Workout' : 'Edit Workout'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...workout.sets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final set = entry.value;
                      return ListTile(
                        title: Text(
                            '${set.exercise} - ${set.weight} kg, ${set.repetitions} reps'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              workout.sets.removeAt(index);
                            });
                          },
                        ),
                        onTap: () => _showEditSetDialog(
                            context, workout, index, setState),
                      );
                    }),
                    ElevatedButton(
                      child: const Text('Add Set'),
                      onPressed: () =>
                          _showAddSetDialog(context, workout, setState),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Expanded(
                  child: TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      final viewModel = Provider.of<WorkoutListViewModel>(
                          context,
                          listen: false);
                      if (isNew) {
                        viewModel.addWorkout(workout);
                      } else {
                        viewModel.updateWorkout(workout);
                      }
                      Navigator.of(context).pop();
                      viewModel.loadWorkouts(); // Refresh the list
                      Navigator.of(context).pop(); // Pop back to HomeScreen
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addNewWorkout(BuildContext context) {
    Provider.of<WorkoutListViewModel>(context, listen: false);
    final newWorkout = Workout(
      id: DateTime.now().toString(),
      sets: [],
      date: DateTime.now(),
    );

    _showWorkoutDialog(context, newWorkout, isNew: true);
  }

  void _showAddSetDialog(
      BuildContext context, Workout workout, StateSetter setState) {
    String selectedExercise = WorkoutSet.exerciseOptions[0];
    double weight = 0;
    int repetitions = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Set'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedExercise,
                  items: WorkoutSet.exerciseOptions.map((String exercise) {
                    return DropdownMenuItem<String>(
                      value: exercise,
                      child: Text(exercise),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedExercise = newValue!;
                  },
                  decoration: const InputDecoration(labelText: 'Exercise'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => weight = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Repetitions'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => repetitions = int.tryParse(value) ?? 0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  workout.sets.add(WorkoutSet(
                    exercise: selectedExercise,
                    weight: weight,
                    repetitions: repetitions,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditSetDialog(
      BuildContext context, Workout workout, int index, StateSetter setState) {
    final set = workout.sets[index];
    String selectedExercise = set.exercise;
    double weight = set.weight;
    int repetitions = set.repetitions;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Set'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedExercise,
                  items: WorkoutSet.exerciseOptions.map((String exercise) {
                    return DropdownMenuItem<String>(
                      value: exercise,
                      child: Text(exercise),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedExercise = newValue!;
                  },
                  decoration: const InputDecoration(labelText: 'Exercise'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  initialValue: weight.toString(),
                  onChanged: (value) => weight = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Repetitions'),
                  keyboardType: TextInputType.number,
                  initialValue: repetitions.toString(),
                  onChanged: (value) => repetitions = int.tryParse(value) ?? 0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  workout.sets[index] = WorkoutSet(
                    exercise: selectedExercise,
                    weight: weight,
                    repetitions: repetitions,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
        }
      },
    );
  }
}
