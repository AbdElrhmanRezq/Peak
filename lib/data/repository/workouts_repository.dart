import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutsRepository {
  SupabaseService _service = SupabaseService();

  Future<void> saveWorkout(WorkoutModel workout) async {
    try {
      await _service.saveWorkout(workout);
      print("Workout Saved");
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<WorkoutModel>> getWorkoutsByUserId(String userId) async {
    try {
      return await _service.getWorkoutsByUserId(userId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      return await _service.deleteWorkout(workoutId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> deleteExercise(int exerciseId) async {
    try {
      return await _service.deleteExercise(exerciseId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> deleteSet(ExerciseModel exercise) async {
    try {
      final int setId = exercise.sets.last.id!;
      return await _service.deleteSet(setId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateSets(List<SetModel> sets) async {
    try {
      sets.forEach((s) async {
        await _service.updateSet(s);
      });
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateWorkout(
    int workoutId,
    String workoutTitle,
    String description,
  ) async {
    try {
      await _service.updateWorkout(workoutId, workoutTitle, description);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> addExercisesToWorkout(
    int workoutId,
    List<ExerciseModel> exercises,
  ) async {
    try {
      for (ExerciseModel exercise in exercises) {
        await _service.addExerciseToWorkout(workoutId, exercise);
      }
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<WorkoutModel>> getPopularWorkouts() async {
    try {
      return await _service.getPopularWorkouts();
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> starWorkout(int workoutId, UserModel currentUser) async {
    final userId = currentUser.id;

    if (userId == null) {
      print("No logged-in user");
      return;
    }

    try {
      return await _service.starWorkout(workoutId, userId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> unstarWorkout(int workoutId, UserModel currentUser) async {
    final userId = currentUser.id;

    if (userId == null) {
      print("No logged-in user");
      return;
    }

    try {
      return await _service.unstarWorkout(workoutId, userId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<bool> isWorkoutStared(String userId, int workoutId) async {
    try {
      final response = await _service.isWorkoutStared(userId, workoutId);
      return response;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<int> getWorkoutStaredCount(int workoutId) async {
    try {
      final response = await _service.getWorkoutStaredCount(workoutId);
      return response;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<WorkoutModel>> searchWorkouts(String searchText) async {
    try {
      return await _service.searchWorkouts(searchText);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> addSet(int exerciseId) async {
    try {
      await _service.addSet(exerciseId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }
}
