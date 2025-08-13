import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/repository/workouts_repository.dart';

final workoutsRepositoryProvider = Provider((ref) => WorkoutsRepository());

final workoutsProvider = FutureProvider<List<WorkoutModel>>((ref) async {
  final workoutRepo = ref.read(workoutsRepositoryProvider);
  return workoutRepo.getWorkouts();
});
