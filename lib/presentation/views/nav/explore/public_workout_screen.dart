import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';

class PublicWorkoutScreen extends ConsumerWidget {
  static const String id = 'public_workout_screen';

  const PublicWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final workout = args['workout']; // workout is already passed in full

    final exercises = workout.exercises as List<ExerciseModel>;

    WorkoutsRepository workoutsRepo = WorkoutsRepository();

    final currentUser = ref.watch(currentUserProvider);

    final isWorkoutStaredAsync = ref.watch(staredStatusProvider(workout.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title, style: theme.textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () async {
              bool isStared = await workoutsRepo.isWorkoutStared(
                currentUser?.id ?? '',
                workout.id,
              );
              isStared
                  ? await workoutsRepo.unstarWorkout(
                      workout.id,
                      currentUser as UserModel,
                    )
                  : await workoutsRepo.starWorkout(
                      workout.id,
                      currentUser as UserModel,
                    );
              ref.invalidate(staredStatusProvider(workout.id));
            },
            icon: Icon(
              Icons.star,
              color: isWorkoutStaredAsync.when(
                data: (data) => data ? Colors.yellow : Colors.grey,
                error: (_, __) => Colors.grey, // <-- must be a function
                loading: () => Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: exercises.isEmpty
          ? const Center(child: Text("No exercises found"))
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.01,
                  ),
                  child: Text(
                    workout.description ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ExpansionTile(
                        leading: CachedNetworkImage(
                          imageUrl: getExerciseGifUrl(exercise.id),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image, size: 40),
                        ),
                        title: Text(
                          exercise.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          'Sets: ${exercise.sets.length}',
                          style: theme.textTheme.titleSmall,
                        ),
                        children: [
                          if (exercise.sets.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No sets for this exercise"),
                            )
                          else
                            _SetsTableReadOnly(sets: exercise.sets),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _SetsTableReadOnly extends StatelessWidget {
  final List<SetModel> sets;
  const _SetsTableReadOnly({required this.sets});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Set #")),
          DataColumn(label: Text("Weight (kg)")),
          DataColumn(label: Text("Reps / Range")),
        ],
        rows: sets.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final set = entry.value;
          return DataRow(
            cells: [
              DataCell(Text("$idx")),
              DataCell(Text(set.weight?.toString() ?? '-')),
              DataCell(
                set.type == "Reps"
                    ? Text(set.reps?.toString() ?? '-')
                    : Text(
                        "${set.repRangeMin ?? '-'} - ${set.repRangeMax ?? '-'}",
                      ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
