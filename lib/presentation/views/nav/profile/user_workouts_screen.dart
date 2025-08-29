import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/presentation/widgets/workout_card.dart';

class UserWorkoutsScreen extends ConsumerWidget {
  static const String id = 'user_workouts_screen';
  const UserWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as List<WorkoutModel>;
    final workouts = args;

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("User Workouts", style: theme.textTheme.headlineMedium),
      ),
      body: workouts.isEmpty
          ? Center(
              child: Text(
                "No workouts found",
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                final starsAsync = ref.watch(
                  staredCountProvider(workout.id ?? 0),
                );

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  child: WorkoutCard(
                    workout: workout,
                    index: index,
                    showButtomSheet: () {},
                    type: 'public',
                  ),
                );
              },
            ),
    );
  }
}
