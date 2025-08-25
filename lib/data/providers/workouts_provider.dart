import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/repository/workouts_repository.dart';

final workoutsRepositoryProvider = Provider((ref) => WorkoutsRepository());

final workoutsProvider = FutureProvider.family<List<WorkoutModel>, String>((
  ref,
  userId,
) async {
  final workoutRepo = ref.read(workoutsRepositoryProvider);
  return workoutRepo.getWorkoutsByUserId(userId);
});

final staredStatusProvider = FutureProvider.family<bool, int>((
  ref,
  workoutId,
) async {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return false;

  return await ref
      .watch(workoutsRepositoryProvider)
      .isWorkoutStared(currentUser.id, workoutId);
});

final staredCountProvider = FutureProvider.family<int, int>((
  ref,
  workoutId,
) async {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return 0;

  return await ref
      .watch(workoutsRepositoryProvider)
      .getWorkoutStaredCount(workoutId);
});
