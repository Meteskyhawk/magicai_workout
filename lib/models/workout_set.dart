class WorkoutSet {
  static const List<String> exerciseOptions = [
    'Barbell row',
    'Bench press',
    'Shoulder press',
    'Deadlift',
    'Squat'
  ];

  String exercise;
  double weight;
  int repetitions;

  WorkoutSet({required this.exercise, required this.weight, required this.repetitions});

  Map<String, dynamic> toJson() => {
    'exercise': exercise,
    'weight': weight,
    'repetitions': repetitions,
  };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
    exercise: json['exercise'],
    weight: json['weight'],
    repetitions: json['repetitions'],
  );
}