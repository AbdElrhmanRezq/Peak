import 'package:repx/data/models/exercise_model.dart';

class WorkoutModel {
  final String title;
  final String? description;
  final List<ExerciseModel> exercises;
  final int? id;
  final String? uId;
  final String? imageUrl;

  WorkoutModel({
    required this.title,
    this.description,
    required this.exercises,
    this.id,
    this.uId,
    this.imageUrl,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      title: json['title'] ?? '',
      description: json['description'],
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
      uId: json['u_id'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'id': id,
      'image_url': imageUrl,
    };
  }
}
