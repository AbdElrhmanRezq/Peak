import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';

class SelectedExercisesNotifier extends StateNotifier<List<ExerciseModel?>> {
  SelectedExercisesNotifier() : super([]);

  void addExercise(ExerciseModel exercise) {
    state = [...state, exercise];
  }

  void removeExercise(ExerciseModel exercise) {
    state = state.where((e) => e?.id != exercise.id).toList();
  }

  void clear() {
    state = [];
  }
}

final selectedExercisesProvider =
    StateNotifierProvider<SelectedExercisesNotifier, List<ExerciseModel?>>(
      (ref) => SelectedExercisesNotifier(),
    );
