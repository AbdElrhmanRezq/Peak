import 'package:repx/data/models/exercise_model.dart';

class WorkoutModel {
  final String title;
  final String? description;
  final List<ExerciseModel> exercises;

  WorkoutModel({
    required this.title,
    this.description,
    required this.exercises,
  });
}
