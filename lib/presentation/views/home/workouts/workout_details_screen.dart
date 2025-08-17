import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:repx/data/services/custom_image_getter.dart';

class WorkoutDetailsScreen extends ConsumerWidget {
  static const String id = 'workout_details_screen';

  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the index passed via Navigator
    final args = ModalRoute.of(context)!.settings.arguments as int;

    final workoutsAsync = ref.watch(workoutsProvider);

    return workoutsAsync.when(
      data: (workouts) {
        if (args < 0 || args >= workouts.length) {
          return const Scaffold(
            body: Center(child: Text('Invalid workout index')),
          );
        }

        final workout = workouts[args];
        final exercises = workout.exercises ?? [];

        return Scaffold(
          appBar: AppBar(title: Text(workout.title), centerTitle: true),
          body: exercises.isEmpty
              ? const Center(child: Text("No exercises found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
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
                        title: Text(exercise.name),
                        subtitle: Text('Sets: ${exercise.sets?.length ?? 0}'),
                        children: [
                          if (exercise.sets?.isEmpty ?? true)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No sets for this exercise"),
                            )
                          else
                            _SetsTable(sets: exercise.sets!),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }
}

class _SetsTable extends StatelessWidget {
  final List<dynamic> sets;
  const _SetsTable({required this.sets});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // in case the table is wide
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Set #")),
          DataColumn(label: Text("Weight (kg)")),
          DataColumn(label: Text("Reps / Range")),
          DataColumn(label: Text("Type")),
        ],
        rows: sets.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final set = entry.value;
          return DataRow(
            cells: [
              DataCell(Text("$idx")),
              DataCell(Text("${set.weight ?? 0}")),
              DataCell(
                Text(
                  set.type == "Reps"
                      ? "${set.reps ?? 0}"
                      : "${set.repRangeMin ?? 0}-${set.repRangeMax ?? 0}",
                ),
              ),
              DataCell(Text(set.type ?? "-")),
            ],
          );
        }).toList(),
      ),
    );
  }
}
