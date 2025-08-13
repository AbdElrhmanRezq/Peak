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
}
