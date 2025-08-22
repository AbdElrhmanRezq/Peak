import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signup(String email, String password) {
    return supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() {
    return supabase.auth.signOut();
  }

  Future<User?> get currentUser async {
    final session = supabase.auth.currentSession;
    return session?.user;
  }

  Future<void> createUser(UserModel user) async {
    // Implement user creation logic if needed
    print('id: ${user.id}, email: ${user.email}, username: ${user.username},');
    await supabase.from('users').insert([
      {
        'email': user.email,
        'username': user.username,
        'gender': user.gender,
        'id': user.id,
      },
    ]);
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    final userId = supabase.auth.currentSession?.user.id;

    // 1. Insert workout
    final workoutRes = await supabase
        .from('workouts')
        .insert({
          'u_id': userId,
          'title': workout.title,
          'description': workout.description,
        })
        .select()
        .single();

    final workoutId = workoutRes['id'];

    // 2. Insert exercises
    for (final exercise in workout.exercises) {
      final exerciseRes = await supabase
          .from('exercises')
          .insert({'w_id': workoutId, 'id': exercise.id, 'name': exercise.name})
          .select()
          .single();

      final eId =
          exerciseRes['s_id']; // Primary key from workout_exercises table

      // 3. Insert sets for this exercise
      final setsData = exercise.sets.map((set) {
        return {
          'e_id': eId, // foreign key to this exercise
          'weight': set.weight,
          'reps': set.reps,
          'repRangeMin': set.repRangeMin,
          'repRangeMax': set.repRangeMax,
          'type': set.type,
        };
      }).toList();

      await supabase.from('sets').insert(setsData);
    }
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    final userId = supabase.auth.currentSession?.user.id;

    if (userId == null) {
      print("No logged-in user");
      return [];
    }

    try {
      final workoutsData = await supabase
          .from('workouts')
          .select()
          .eq('u_id', userId);

      final workouts = workoutsData
          .map((w) => WorkoutModel.fromJson(w))
          .toList();

      for (WorkoutModel workout in workouts) {
        final exercisesData = await supabase
            .from('exercises')
            .select()
            .eq('w_id', workout.id ?? "");

        final exercises = exercisesData
            .map((e) => ExerciseModel.fromJson(e))
            .toList();

        for (ExerciseModel exercise in exercises) {
          final setsData = await supabase
              .from('sets')
              .select()
              .eq('e_id', exercise.supaId ?? "");

          final sets = setsData.map((s) => SetModel.fromJson(s)).toList();
          exercise.sets.clear();
          exercise.sets.addAll(sets);
        }
        workout.exercises.addAll(exercises);
      }

      print('Fetched workouts: $workouts');
      print('Fetched exercises for w1: ${workouts[0].exercises}');
      print('Fetched exercises for w1 e1: ${workouts[0].exercises[0].name}');

      if (workouts == null) return [];

      return workouts;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return [];
    } catch (e) {
      print('Unknown error: $e');
      return [];
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      await supabase.from('workouts').delete().eq('id', workoutId);
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
      await supabase.from('exercises').delete().eq('s_id', exerciseId);
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
      await supabase.from('sets').delete().eq('id', setId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateSet(SetModel set) async {
    try {
      await supabase.from('sets').update(set.toJson()).eq('id', set.id!);
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
      print(workoutId);
      await supabase
          .from('workouts')
          .update({'title': workoutTitle, 'description': description})
          .eq('id', workoutId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> addExerciseToWorkout(
    int workoutId,
    ExerciseModel exercise,
  ) async {
    try {
      final exerciseRes = await supabase
          .from('exercises')
          .insert({'w_id': workoutId, 'id': exercise.id, 'name': exercise.name})
          .select()
          .single();

      final eId = exerciseRes['s_id'];

      final setsData = exercise.sets.map((set) {
        return {
          'e_id': eId, // foreign key to this exercise
          'weight': set.weight,
          'reps': set.reps,
          'repRangeMin': set.repRangeMin,
          'repRangeMax': set.repRangeMax,
          'type': set.type,
        };
      }).toList();

      await supabase.from('sets').insert(setsData);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }
}
