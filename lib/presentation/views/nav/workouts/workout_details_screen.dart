import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/providers/sets_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';

final _formKey = GlobalKey<FormState>();

class WorkoutDetailsScreen extends ConsumerWidget {
  static const String id = 'workout_details_screen';

  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final theme = Theme.of(context);
    //Next to be done: Add sets
    //Implement editted sets
    //Delete exercise/set
    //UI to match the other screen
    final args = ModalRoute.of(context)!.settings.arguments as int;

    final authRepo = ref.watch(authRepositoryProvider);

    final currentUser = authRepo.currentUser;

    final workoutsAsync = ref.watch(workoutsProvider(currentUser?.id ?? ''));

    final WorkoutsRepository workoutRep = WorkoutsRepository();

    final List<SetModel> changedSets = ref.watch(changedSetsProvider);

    return workoutsAsync.when(
      data: (workouts) {
        if (args < 0 || args >= workouts.length) {
          return const Scaffold(
            body: Center(child: Text('Invalid workout index')),
          );
        }

        final workout = workouts[args];
        titleController.text = workout.title;
        descriptionController.text = workout.description ?? ' ';
        final exercises = workout.exercises;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                ref.invalidate(selectedExercisesProvider);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(
                    "select_exercises_screen",
                    arguments: {'workoutReady': true, 'workoutId': workout.id},
                  );
                },
                icon: Icon(
                  Icons.add,

                  color: changedSets.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (changedSets.isNotEmpty) {
                    try {
                      await workoutRep.updateSets(changedSets);
                      ref.invalidate(changedSetsProvider);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Saved')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Saving failed: ${e}')),
                      );
                    }
                  }
                },
                icon: Icon(
                  Icons.save,

                  color: changedSets.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      title: Text(
                        "Change title",
                        style: theme.textTheme.headlineMedium,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              style: theme.textTheme.headlineMedium,
                              decoration: InputDecoration(
                                hintText: "Workout title",
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              controller: titleController,

                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Please enter a title for workout'
                                  : null,
                            ),
                          ),
                          TextFormField(
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "Workout description",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            controller: descriptionController,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await workoutRep.updateWorkout(
                                workout.id as int,
                                titleController.text.trim(),
                                descriptionController.text.trim(),
                              );
                              ref.invalidate(workoutsProvider);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Save"),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
              SizedBox(width: width * 0.02),
            ],
          ),
          body: exercises.isEmpty
              ? const Center(child: Text("No exercises found"))
              : Column(
                  children: [
                    Text(workout.title, style: theme.textTheme.headlineLarge),
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
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                            title: Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              'Sets: ${exercise.sets.length}',
                              style: theme.textTheme.titleSmall,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showButtomSheetCustom(
                                  ref,
                                  context,
                                  width,
                                  height,
                                  workoutRep,
                                  exercise,
                                  changedSets,
                                );
                              },
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: theme.primaryColor,
                              ),
                            ),
                            children: [
                              if (exercise.sets.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("No sets for this exercise"),
                                )
                              else
                                _SetsTable(sets: exercise.sets),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  void showButtomSheetCustom(
    WidgetRef ref,
    BuildContext context,
    width,
    height,
    WorkoutsRepository workoutRep,
    ExerciseModel exercise,
    List<SetModel> changedSets,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  radius: BorderRadius.circular(12),
                  endIndent: width * 0.35,
                  indent: width * 0.35,
                  thickness: 5,
                ),
              ),
              ListTile(
                onTap: () async {
                  await workoutRep.deleteExercise(exercise.supaId as int);
                  ref.invalidate(workoutsProvider);
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.cancel_outlined, color: Colors.white),
                title: Text(
                  "Delete exercise",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                onTap: () async {
                  await workoutRep.addSet(exercise.supaId as int);
                  ref.invalidate(workoutsProvider);
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.cancel_outlined, color: Colors.white),
                title: Text(
                  "Add set",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                onTap: () async {
                  // await workoutRep.deleteExercise(exerciseId);
                  // ref.invalidate(workoutsProvider);
                  exercise.sets.forEach((s) {
                    s.type = s.type == "Reps" ? "Rep Range" : "Reps";
                    if (changedSets.contains(s)) {
                      changedSets.remove(s);
                      ref.watch(changedSetsProvider.notifier).addSet(s);
                    } else {
                      ref.watch(changedSetsProvider.notifier).addSet(s);
                    }
                  });

                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.change_circle, color: Colors.white),
                title: Text(
                  exercise.sets[0].type == "Reps"
                      ? "Convert to Rep Range"
                      : "Convert to Reps",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SetsTable extends ConsumerWidget {
  final List<dynamic> sets;
  const _SetsTable({required this.sets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changedSets = ref.watch(changedSetsProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // in case the table is wide
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Set #")),
          DataColumn(label: Text("Weight (kg)")),
          DataColumn(label: Text("Reps / Range")),
          //DataColumn(label: Text("Type")),
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
                        : ref.watch(changedSetsProvider.notifier).addSet(set);
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
                                    .watch(changedSetsProvider.notifier)
                                    .addSet(set);
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
                                          .watch(changedSetsProvider.notifier)
                                          .addSet(set);
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
                                          .watch(changedSetsProvider.notifier)
                                          .addSet(set);
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
