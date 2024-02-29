class Exercise {
  final String name;
  final List<double> multipliers;
  final List<int> reps;

  Exercise({
    required this.name,
    required this.multipliers,
    required this.reps,
  });
}

class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  });
}

class WorkoutStore {
  final List<Workout> workouts = [
    Workout(
      name: 'Bench Press / OHP',
      exercises: [
        Exercise(
          name: 'Bench Press',
          multipliers: [0.65, 0.75, 0.85, 0.85, 0.85, 0.8, 0.75, 0.7, 0.65],
          reps: [8, 6, 4, 4, 4, 5, 6, 7, 8],
        ),
        Exercise(
          name: 'OHP',
          multipliers: [0.5, 0.6, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7],
          reps: [6, 5, 3, 5, 7, 4, 6, 8],
        ),
      ],
    ),
    Workout(
      name: 'Deadlift / Front Squat',
      exercises: [
        Exercise(
          name: 'Deadlift',
          multipliers: [0.75, 0.85, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65],
          reps: [5, 3, 1, 3, 3, 3, 3, 3, 3],
        ),
        Exercise(
          name: 'Front Squat',
          multipliers: [0.35, 0.45, 0.55, 0.55, 0.55, 0.55, 0.55, 0.55],
          reps: [5, 5, 3, 5, 7, 4, 6, 8],
        ),
      ],
    ),
  ];
}
