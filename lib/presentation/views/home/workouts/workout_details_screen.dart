import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/providers/sets_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:repx/data/services/custom_image_getter.dart';

class WorkoutDetailsScreen extends ConsumerWidget {
  static const String id = 'workout_details_screen';

  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Next to be done: Add sets
    //Implement editted sets
    //Delete exercise/set
    //UI to match the other screen
    final args = ModalRoute.of(context)!.settings.arguments as int;

    final workoutsAsync = ref.watch(workoutsProvider);

    final List<SetModel> changedSets = ref.watch(setsProvider);

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
          appBar: AppBar(
            title: Text(workout.title),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check_sharp,
                  color: changedSets.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
              ),
            ],
          ),
          body: exercises.isEmpty
              ? const Center(child: Text("No exercises found"))
              : ListView.builder(
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        'Sets: ${exercise.sets?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      children: [
                        if (exercise.sets?.isEmpty ?? true)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No sets for this exercise"),
                          )
                        else
                          _SetsTable(sets: exercise.sets!),
                      ],
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

class _SetsTable extends ConsumerWidget {
  final List<dynamic> sets;
  const _SetsTable({required this.sets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changedSets = ref.watch(setsProvider);
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

              // Weight editable
              DataCell(
                TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  initialValue: set.weight?.toString() ?? '',
                  decoration: const InputDecoration(hintText: "kg"),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    final trimmed = val.trim();
                    set.weight = trimmed.isEmpty
                        ? 0
                        : double.tryParse(trimmed) ?? 0;
                    changedSets.contains(set)
                        ? null
                        : ref.watch(setsProvider.notifier).addChangedSet(set);
                  },
                ),
              ),

              // Reps / Range editable
              DataCell(
                set.type == "Reps"
                    ? TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        initialValue: set.reps?.toString() ?? '',
                        decoration: const InputDecoration(hintText: "reps"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final trimmed = val.trim();
                          set.reps = trimmed.isEmpty
                              ? 0
                              : int.tryParse(trimmed) ?? 0;
                          changedSets.contains(set)
                              ? null
                              : ref
                                    .watch(setsProvider.notifier)
                                    .addChangedSet(set);
                        },
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              initialValue: set.repRangeMin?.toString() ?? '',
                              decoration: const InputDecoration(
                                hintText: "min",
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                final trimmed = val.trim();
                                set.repRangeMin = trimmed.isEmpty
                                    ? 0
                                    : int.tryParse(trimmed) ?? 0;
                                changedSets.contains(set)
                                    ? null
                                    : ref
                                          .watch(setsProvider.notifier)
                                          .addChangedSet(set);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              initialValue: set.repRangeMax?.toString() ?? '',
                              decoration: const InputDecoration(
                                hintText: "max",
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                final trimmed = val.trim();
                                set.repRangeMax = trimmed.isEmpty
                                    ? 0
                                    : int.tryParse(trimmed) ?? 0;
                                changedSets.contains(set)
                                    ? null
                                    : ref
                                          .watch(setsProvider.notifier)
                                          .addChangedSet(set);
                              },
                            ),
                          ),
                        ],
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
