import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_tracker/features/workout/workout_list_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/workout_viewmodel.dart';
import '../../models/workout.dart';
import '../../models/workout_set.dart';

class WorkoutScreen extends StatelessWidget {
  final Workout? workout;

  const WorkoutScreen({Key? key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutViewModel()
        ..setWorkout(workout ??
            Workout(
                id: DateTime.now().toString(), sets: [], date: DateTime.now())),
      child: Consumer<WorkoutViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(workout == null ? 'New Workout' : 'Edit Workout'),
              backgroundColor: Colors.blue,
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveWorkout(context),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: viewModel.workout?.sets.length ?? 0,
              itemBuilder: (context, index) {
                return _buildSetCard(context, viewModel, index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddSetDialog(context, viewModel),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSetCard(
      BuildContext context, WorkoutViewModel viewModel, int index) {
    final set = viewModel.workout!.sets[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('${set.exercise} - ${set.weight} kg'),
        subtitle: Text('${set.repetitions} reps'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => viewModel.removeSet(index),
        ),
        onTap: () => _showEditSetDialog(context, viewModel, index, set),
      ),
    );
  }

  void _showAddSetDialog(BuildContext context, WorkoutViewModel viewModel) {
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
                viewModel.addSet(WorkoutSet(
                  exercise: selectedExercise,
                  weight: weight,
                  repetitions: repetitions,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditSetDialog(BuildContext context, WorkoutViewModel viewModel,
      int index, WorkoutSet set) {
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
                viewModel.updateSet(
                  index,
                  WorkoutSet(
                    exercise: selectedExercise,
                    weight: weight,
                    repetitions: repetitions,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveWorkout(BuildContext context) {
    final workoutListViewModel =
        Provider.of<WorkoutListViewModel>(context, listen: false);
    final currentWorkout =
        Provider.of<WorkoutViewModel>(context, listen: false).workout;
    if (currentWorkout != null) {
      if (kDebugMode) {
        print("Saving workout: ${currentWorkout.toJson()}");
      } // Add this line
      workoutListViewModel.addWorkout(currentWorkout);
      Navigator.of(context).pop();
    }
  }
}
