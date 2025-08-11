import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/services/custom_image_getter.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class CreateWorkoutScreen extends ConsumerWidget {
  static const String id = 'create_workout_screen';
  const CreateWorkoutScreen({super.key});

  void saveWorkout() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
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
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.2,
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
                  return ListTile(
                    title: Text(exercises[index]?.name as String),
                    leading: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: getExerciseGifUrl(exercises[index].id),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(selectedExercisesProvider.notifier)
                            .removeExercise(exercises[index] as ExerciseModel);
                      },
                      icon: Icon(Icons.cancel),
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
