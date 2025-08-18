import 'package:repx/data/models/set_model.dart';
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

  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      return await _service.getWorkouts();
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

  Future<void> deleteSet(int setId) async {
    try {
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
}
