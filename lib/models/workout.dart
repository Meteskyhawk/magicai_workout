import 'workout_set.dart';

class Workout {
  String id;
  List<WorkoutSet> sets;
  DateTime date;

  Workout({required this.id, required this.sets, required this.date});

  Map<String, dynamic> toJson() => {
    'id': id,
    'sets': sets.map((set) => set.toJson()).toList(),
    'date': date.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'],
    sets: (json['sets'] as List).map((set) => WorkoutSet.fromJson(set)).toList(),
    date: DateTime.parse(json['date']),
  );
}