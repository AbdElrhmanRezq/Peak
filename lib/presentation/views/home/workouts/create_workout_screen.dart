import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/services/custom_image_getter.dart';
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

  void saveWorkout() {}

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
          IconButton(
            onPressed: () {
              saveWorkout();
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
              height: height * 0.1,
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
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: ListTile(
                      title: Text(
                        exercises[index].name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        "Sets: ${exercises[index].sets?.length.toString() as String}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      leading: Container(
                        width: width * 0.15,
                        height: height * 0.15,
                        child: CachedNetworkImage(
                          imageUrl: getExerciseGifUrl(exercises[index].id),
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
                                      onTap: () {},
                                      leading: Icon(
                                        Icons.list,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        "Manage sets",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        ref
                                            .read(
                                              selectedExercisesProvider
                                                  .notifier,
                                            )
                                            .removeExercise(
                                              exercises[index] as ExerciseModel,
                                            );
                                        Navigator.of(context).pop();
                                      },
                                      leading: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        "Remove exercise",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
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
                    ),
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
