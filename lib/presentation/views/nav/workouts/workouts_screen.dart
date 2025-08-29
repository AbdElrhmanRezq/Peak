import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/image_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/images_repository.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';
import 'package:repx/presentation/widgets/workout_card.dart';

class WorkoutsScreen extends ConsumerWidget {
  static const String id = 'workouts_screen';
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    WorkoutsRepository workoutsRep = WorkoutsRepository();

    final authRepo = ref.watch(authRepositoryProvider);

    final currentUser = authRepo.currentUser;

    final workoutsAsync = ref.watch(workoutsProvider(currentUser?.id ?? ''));

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final choosing = args?['choosing'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workouts",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            CustomIconTextButton(
              title: "Add Workout",
              icon: Icons.add,
              onPressed: () {
                Navigator.of(context).pushNamed('create_workout_screen');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Workouts",
                style: theme.textTheme.headlineLarge,
              ),
            ),
            workoutsAsync.when(
              data: (workouts) {
                if (workouts.isEmpty) {
                  return Text("No workouts found.");
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.01),
                        child: WorkoutCard(
                          index: index,
                          workout: workout,
                          choosing: choosing,
                          showButtomSheet: () {
                            showButtomSheetCustom(
                              ref,
                              context,
                              width,
                              height,
                              workoutsRep,
                              workout.id as int,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showButtomSheetCustom(
    WidgetRef ref,
    BuildContext context,
    width,
    height,
    WorkoutsRepository workoutRep,
    int workoutId,
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
                  final imageHelper = ref.watch(imageHelperProvider);
                  final file = await imageHelper.pickImage();
                  if (file != null) {
                    final croppedImage = await imageHelper.crop(file: file);
                    if (croppedImage != null) {
                      await uploadImage(croppedImage, workoutId);
                      ref.invalidate(workoutsProvider);
                    }
                  }
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.photo, color: Colors.white),
                title: Text(
                  "Update photo Workout",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                onTap: () async {
                  await workoutRep.deleteWorkout(workoutId);
                  ref.invalidate(workoutsProvider);
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.cancel_outlined, color: Colors.white),
                title: Text(
                  "Delete Workout",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  uploadImage(CroppedFile file, int workoutId) async {
    ImagesRepository imageRep = ImagesRepository();
    await imageRep.uploadWorkoutImage(file, workoutId);
  }
}
