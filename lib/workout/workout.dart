import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_suns/workout/workout_store.dart';

import '../shared_prefs_helper.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  String _name = "Bench Press / OHP";
  double _currentWeight = 0;
  int _currentReps = 0;
  int _currentlyAtSet = 0;
  List _oneRepMaxPerExerciseOfCurrentWorkout = [147.5, 82.5];
  int _setTimeInSeconds = 0; // Time spent on current set
  int _workoutTimeInSeconds = 0; // Total time spent on workout
  Timer? _timer;
  late Workout workout;


  @override
  void initState() {
    super.initState();
    _loadWorkoutName().then((_) {
      setState(() {
        workout = WorkoutStore().workouts.firstWhere((workout) => workout.name == _name);
      });
    });
    _startPeriodicTimer();
    weightController.text = _currentWeight.toString();
    repsController.text = _currentReps.toString();
  }

  void _startPeriodicTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _setTimeInSeconds++;
        _workoutTimeInSeconds++;
      });
    });
  }

  void _resetSetTime() {
    setState(() {
      _setTimeInSeconds = 0;
    });
  }

  Future<void> _loadWorkoutName() async {
    final name = await sharedPrefsHelper.loadWorkoutName();
    setState(() {
      //TODO : make it return the retrieved name instead of this constant one
      _name = "Bench Press / OHP";
    });
  }

  void _changeWeight(String newWeight) {
    if (newWeight.isEmpty ||
        double.parse(newWeight) == _currentWeight ||
        double.parse(newWeight) < 0) {
      return;
    }
    setState(() {
      _currentWeight = double.parse(double.parse(newWeight).toStringAsFixed(2));
      weightController.text = _currentWeight.toString();
    });
  }

  void _addWeight(double weightToAdd) {
    _changeWeight((_currentWeight + weightToAdd).toString());
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout ($_name)'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              "${formatTime(_setTimeInSeconds)} / ${formatTime(_workoutTimeInSeconds)}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: workout.exercises.length,
              itemBuilder: (BuildContext context, int exerciseIndex) {
                var exercise = workout.exercises[exerciseIndex];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercise.multipliers.length + 1,
                  itemBuilder: (BuildContext context, int setIndex) {
                    if (setIndex == 0) {
                      return ListTile(
                        tileColor: Theme.of(context).primaryColor,
                        title: Text(
                            exercise.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                          ),
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text(
                          '${exercise.reps[setIndex - 1]} x ${(exercise.multipliers[setIndex - 1] * _oneRepMaxPerExerciseOfCurrentWorkout[exerciseIndex]).floor() - (exercise.multipliers[setIndex - 1] * _oneRepMaxPerExerciseOfCurrentWorkout[exerciseIndex]).floor() % 2.5}kg',                                style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildItem(ElevatedButton(onPressed: () {
                    _addWeight(-2.5);
                  }, child: const Icon(Icons.remove)), 1),
                  _buildItem(
                      TextField(
                        controller: weightController,
                        onChanged: (String value) {
                          _changeWeight(value);
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus(); // Unfocus the TextField when OK is pressed
                        },
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')), // Allow only numbers and a single decimal point
                        ],
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      1),
                  _buildItem(ElevatedButton(onPressed: () {
                    _addWeight(2.5);
                  }, child: const Icon(Icons.add)), 1),
                ],
              ),
              Row(
                children: [],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Widget content, [int flex = 1]) {
    return Flexible(
      flex: flex,
      child: Center(
        child: content,
      ),
    );
  }
}
