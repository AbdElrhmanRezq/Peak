import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';
import 'package:repx/presentation/widgets/custom_icon_button.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  static const String id = 'create_workout_screen';
  const CreateWorkoutScreen({super.key});

  @override
  ConsumerState<CreateWorkoutScreen> createState() =>
      _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> saveWorkout(List<ExerciseModel> exercises) async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    ref.read(workoutLoadingProvider.notifier).state = true;
    try {
      WorkoutsRepository workoutsRepository = WorkoutsRepository();
      await workoutsRepository.saveWorkout(
        WorkoutModel(
          title: title,
          description: description,
          exercises: exercises,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Saveing failed: ${e}')));
    } finally {
      ref.read(workoutLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(selectedExercisesProvider);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Workout",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          ref.watch(workoutLoadingProvider)
              ? CircularProgressIndicator()
              : IconButton(
                  onPressed: () async {
                    await saveWorkout(exercises);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check_sharp, color: Colors.white),
                ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.02,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.05,
              child: TextFormField(
                style: Theme.of(context).textTheme.headlineLarge,
                decoration: InputDecoration(
                  hintText: "Workout title",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                controller: titleController,
              ),
            ),
            Container(
              height: height * 0.05,
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Discribtion",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                controller: descriptionController,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: CustomExpansionTile(exercise: exercise),
                  );
                },
              ),
            ),
            CustomWideButton(
              text: "Add Exercises",
              onPressed: () {
                Navigator.of(context).pushNamed('select_exercises_screen');
              },
              textColor: Colors.black,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionTile extends ConsumerWidget {
  final ExerciseModel exercise;
  const CustomExpansionTile({required this.exercise, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(selectedExercisesProvider);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ExpansionTile(
      title: Text(
        exercise.name.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        "Sets: ${exercise.sets?.length.toString() as String}",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      leading: Container(
        width: width * 0.15,
        height: height * 0.15,
        child: CachedNetworkImage(
          imageUrl: getExerciseGifUrl(exercise.id),
          fit: BoxFit.fitHeight,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
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
                      onTap: () {
                        ref
                            .read(selectedExercisesProvider.notifier)
                            .updateExerciseSets(
                              exercise.id,
                              SetModel(reps: 10),
                            );
                        Navigator.of(context).pop();
                      },
                      leading: Icon(Icons.add, color: Colors.white),
                      title: Text(
                        "Add set",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        exercise.sets[0].type == "Reps"
                            ? ref
                                  .read(selectedExercisesProvider.notifier)
                                  .changeAllSetsToRepRange(exercise.id)
                            : ref
                                  .read(selectedExercisesProvider.notifier)
                                  .changeAllSetsToReps(exercise.id);
                        ;
                        Navigator.of(context).pop();
                      },
                      leading: Icon(Icons.change_circle, color: Colors.white),
                      title: Text(
                        exercise.sets[0].type == "Reps"
                            ? "Convert to Rep range"
                            : "Convert to Reps",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        ref
                            .read(selectedExercisesProvider.notifier)
                            .removeExercise(exercise as ExerciseModel);
                        Navigator.of(context).pop();
                      },
                      leading: Icon(Icons.cancel_outlined, color: Colors.white),
                      title: Text(
                        "Remove exercise",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(
          Icons.more_vert_rounded,
          color: Theme.of(context).primaryColor,
        ),
      ),
      children: [
        exercise.sets[0].type == "Reps"
            ? DataTable(
                columns: const [
                  DataColumn(label: Text('Set')),
                  DataColumn(label: Text('Weight')),
                  DataColumn(label: Text('Reps')),
                  //DataColumn(label: Text('Previous')),
                ],
                rows: List.generate(exercise.sets?.length as int, (index) {
                  final set = exercise.sets?[index];
                  return DataRow(
                    cells: [
                      DataCell(Text((index + 1).toString())),

                      // Weight
                      DataCell(
                        TextFormField(
                          initialValue: set?.weight?.toString() ?? '',
                          decoration: const InputDecoration(hintText: 'kg'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          onChanged: (val) {
                            final trimmed = val.trim();
                            set?.weight = trimmed.isEmpty
                                ? 0
                                : double.tryParse(trimmed) ?? 0;
                          },
                        ),
                      ),

                      // Reps
                      DataCell(
                        TextFormField(
                          initialValue: set?.reps?.toString() ?? '',
                          decoration: const InputDecoration(hintText: 'reps'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) {
                            final trimmed = val.trim();
                            set?.reps = trimmed.isEmpty
                                ? 0
                                : int.tryParse(trimmed) ?? 0;
                          },
                        ),
                      ),

                      // Prev
                      // DataCell(
                      //   TextFormField(
                      //     initialValue: set?.prev ?? '',
                      //     decoration: const InputDecoration(hintText: 'Sets x KG'),
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //     readOnly: true,
                      //   ),
                      // ),
                    ],
                  );
                }),
              )
            : DataTable(
                columns: const [
                  DataColumn(label: Text('Set')),
                  DataColumn(label: Text('Weight')),
                  DataColumn(label: Text('Min')),
                  DataColumn(label: Text('Max')),
                  //DataColumn(label: Text('Previous')),
                ],
                rows: List.generate(exercise.sets?.length as int, (index) {
                  final set = exercise.sets?[index];
                  return DataRow(
                    cells: [
                      DataCell(Text((index + 1).toString())),

                      // Weight
                      DataCell(
                        TextFormField(
                          initialValue: set?.weight?.toString() ?? '',
                          decoration: const InputDecoration(hintText: 'kg'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          onChanged: (val) {
                            final trimmed = val.trim();
                            set?.weight = trimmed.isEmpty
                                ? 0
                                : double.tryParse(trimmed) ?? 0;
                          },
                        ),
                      ),

                      // Reps
                      DataCell(
                        TextFormField(
                          initialValue: set?.repRangeMin?.toString() ?? '',
                          decoration: const InputDecoration(hintText: 'Min'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) {
                            final trimmed = val.trim();
                            set?.repRangeMin = trimmed.isEmpty
                                ? 0
                                : int.tryParse(trimmed) ?? 0;
                          },
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: set?.repRangeMax?.toString() ?? '',
                          decoration: const InputDecoration(hintText: 'Max'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) {
                            final trimmed = val.trim();
                            set?.repRangeMax = trimmed.isEmpty
                                ? 0
                                : int.tryParse(trimmed) ?? 0;
                          },
                        ),
                      ),

                      // Prev
                      // DataCell(
                      //   TextFormField(
                      //     initialValue: set?.prev ?? '',
                      //     decoration: const InputDecoration(hintText: 'Sets x KG'),
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //     readOnly: true,
                      //   ),
                      // ),
                    ],
                  );
                }),
              ),
      ],
    );
  }
}
