import 'package:repx/data/models/set_model.dart';

class ExerciseModel {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final String equipment;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String description;
  final String difficulty;
  final String category;
  final String? note;
  final List<SetModel> sets;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.secondaryMuscles,
    required this.instructions,
    required this.description,
    required this.difficulty,
    required this.category,
    this.note,
    List<SetModel>? sets,
  }) : sets = sets ?? [SetModel()];

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? bodyPart,
    String? target,
    String? equipment,
    List<String>? secondaryMuscles,
    List<String>? instructions,
    String? description,
    String? difficulty,
    String? category,
    String? note,
    List<SetModel>? sets,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyPart: bodyPart ?? this.bodyPart,
      target: target ?? this.target,
      equipment: equipment ?? this.equipment,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      note: note ?? this.note,
      sets: sets ?? this.sets,
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      target: json['target'] ?? '',
      equipment: json['equipment'] ?? '',
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? '',
      category: json['category'] ?? '',
      note: json['note'],
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map(
                (e) => SetModel(
                  prev: e['prev'],
                  weight: (e['weight'] ?? 50).toDouble(),
                  reps: e['reps'],
                  repRangeMin: e['repRangeMin'],
                  repRangeMax: e['repRangeMax'],
                  type: e['type'] ?? "Reps",
                ),
              )
              .toList() ??
          [SetModel(reps: 10)],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'target': target,
      'equipment': equipment,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'description': description,
      'difficulty': difficulty,
      'category': category,
      'note': note,
      'sets': sets
          .map(
            (set) => {
              'prev': set.prev,
              'weight': set.weight,
              'reps': set.reps,
              'repRangeMin': set.repRangeMin,
              'repRangeMax': set.repRangeMax,
              'type': set.type,
            },
          )
          .toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
