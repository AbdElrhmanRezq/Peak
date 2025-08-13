import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                            color: Theme.of(context).colorScheme.secondary,
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
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              subtitle: Text(workout.description ?? ''),
                              leading: Icon(
                                Icons.fitness_center,
                                size: height * 0.04,
                                color: Theme.of(context).primaryColor,
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
}
