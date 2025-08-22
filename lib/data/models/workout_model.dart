import 'package:repx/data/models/exercise_model.dart';

class WorkoutModel {
  final String title;
  final String? description;
  final List<ExerciseModel> exercises;
  final int? id;
  final int? stars;

  WorkoutModel({
    required this.title,
    this.description,
    required this.exercises,
    this.id,
    this.stars,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      title: json['title'] ?? '',
      description: json['description'],
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
      stars: json['stars'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }
}
