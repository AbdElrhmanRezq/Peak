import 'package:image_cropper/image_cropper.dart';
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
    await supabase.from('users').insert([
      {
        'email': user.email,
        'username': user.username,
        'gender': user.gender,
        'id': user.id,
        'name': user.name,
        'weight': user.weight,
        'height': user.height,
        'age': user.age,
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

  Future<List<WorkoutModel>> getWorkoutsByUserId(String userId) async {
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

  Future<List<WorkoutModel>> getPopularWorkouts({
    int limit = 10,
    int page = 1,
  }) async {
    try {
      int offset = limit * (page - 1);
      final workoutsData = await supabase
          .from('workouts')
          .select()
          .order('stars', ascending: false)
          .limit(limit);

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

      return workouts;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> starWorkout(int workoutId, String userId) async {
    try {
      await supabase.from('stars').insert({'w_id': workoutId, 'u_id': userId});
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> unstarWorkout(int workoutId, String userId) async {
    try {
      await supabase
          .from('stars')
          .delete()
          .eq('w_id', workoutId)
          .eq('u_id', userId);
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
      final response = await supabase
          .from('stars')
          .select()
          .eq('u_id', userId)
          .eq('w_id', workoutId)
          .maybeSingle(); // <-- does not throw if no row
      print(response);
      return response != null;
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
      final rows = await Supabase.instance.client
          .from('stars')
          .select('id')
          .eq('w_id', workoutId);

      return (rows as List).length;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<String> uploadImage(
    CroppedFile file,
    String folder,
    String name,
  ) async {
    try {
      final imageExtension = file.path.split('.').last.toLowerCase();
      final imageBytes = await file.readAsBytes();

      final imagePath =
          '${supabase.auth.currentUser?.id}/$name.$imageExtension';

      // Upload to Supabase
      await supabase.storage
          .from('$folder')
          .uploadBinary(
            imagePath,
            imageBytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/$imageExtension',
            ),
          );

      print('Image uploaded: $imagePath');

      return supabase.storage.from('$folder').getPublicUrl(imagePath);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateProfileImage(String imageURL) async {
    try {
      final String currentUser = supabase.auth.currentUser?.id ?? '';
      await supabase
          .from('users')
          .update({'profile_picture_url': imageURL})
          .eq('id', currentUser);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateWorkoutImage(String imageURL, int workoutId) async {
    try {
      await supabase
          .from('workouts')
          .update({'image_url': imageURL})
          .eq('id', workoutId);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<WorkoutModel>> searchWorkouts(String searchText) {
    List<WorkoutModel> workouts = [];
    try {
      return supabase
          .from('workouts')
          .select()
          .ilike('title', '%$searchText%')
          .then((workoutsData) {
            workouts = workoutsData
                .map((w) => WorkoutModel.fromJson(w))
                .toList();
            return workouts;
          });
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> addSet(int exerciseId) async {
    try {
      await supabase.from('sets').insert({'e_id': exerciseId});
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> updateStreak(int newStreak, DateTime newLastActivity) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return; // no logged-in user
    try {
      await supabase
          .from('users')
          .update({
            'streak': newStreak,
            'last_activity': newLastActivity.toIso8601String().split('T').first,
          })
          .eq('id', currentUser.id);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<WorkoutModel>> getStarredWorkouts() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('No logged in user');

    try {
      final response = await supabase
          .from('stars')
          .select('workouts(*)')
          .eq('u_id', userId);

      final data = response as List;

      final workouts = data
          .map((star) => WorkoutModel.fromJson(star['workouts']))
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
      return workouts;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<UserModel>> getSuggestedFriends() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('No logged in user');

    try {
      final followsResponse = await supabase
          .from('follows')
          .select('followed_id')
          .eq('follower_id', userId);

      final followedIds = (followsResponse as List)
          .map((f) => f['followed_id'])
          .toList();

      followedIds.add(userId);

      final suggestedFriendsResponse = await supabase
          .from('users')
          .select()
          .not('id', 'in', followedIds)
          .limit(10);

      return (suggestedFriendsResponse as List)
          .map((u) => UserModel.fromJson(u))
          .toList();
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }
}
