import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:repx/data/providers/image_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/images_repository.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    WorkoutsRepository workoutsRep = WorkoutsRepository();

    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workouts",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No workouts found."),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.01),
                        child: Container(
                          height: height * 0.1,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'workout_details_screen',
                                  arguments: index,
                                );
                              },
                              title: Text(
                                workout.title,
                                style: theme.textTheme.headlineMedium,
                              ),
                              subtitle: Text(
                                workout.description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Container(
                                width: width * 0.15,
                                height: width * 0.15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: workout.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            workout.imageUrl!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: workout.imageUrl == null
                                    ? Icon(
                                        Icons.fitness_center,
                                        size: height * 0.04,
                                        color: theme.primaryColor,
                                      )
                                    : null,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showButtomSheetCustom(
                                    ref,
                                    context,
                                    width,
                                    height,
                                    workoutsRep,
                                    workout.id as int,
                                  );
                                },
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
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
