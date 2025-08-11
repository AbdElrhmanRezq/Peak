import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/repository/api_repository.dart';

class SelectedExercisesNotifier extends StateNotifier<List<ExerciseModel>> {
  SelectedExercisesNotifier() : super([]);

  void addExercise(ExerciseModel exercise) {
    if (!state.contains(exercise)) {
      state = [...state, exercise];
    }
  }

  void removeExercise(ExerciseModel exercise) {
    state = state.where((e) => e.id != exercise.id).toList();
  }

  void clear() {
    state = [];
  }
}

final selectedExercisesProvider =
    StateNotifierProvider<SelectedExercisesNotifier, List<ExerciseModel>>(
      (ref) => SelectedExercisesNotifier(),
    );

final exercisesByBodyPartProvider =
    FutureProvider.family<List<ExerciseModel>, String>((ref, bodyPart) {
      final api = ApiRepository();
      return api.getTargetBodyPartsExercises(bodyPart, "1", limit: 10);
    });

final searchedExercisesProvider =
    FutureProvider.family<List<ExerciseModel>, String>((ref, searchText) async {
      if (searchText.trim().isEmpty) {
        return []; // nothing to search
      }
      final apiRepository = ApiRepository();
      return await apiRepository.getSearchedExercises(searchText);
    });
