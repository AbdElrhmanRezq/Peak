import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/workouts_provider.dart';

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
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          'public_workout_screen',
                          arguments: {'workout': workout},
                        );
                      },
                      leading: Container(
                        width: width * 0.15,
                        height: width * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: workout.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(workout.imageUrl!),
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
                      title: Text(
                        workout.title,
                        style: theme.textTheme.headlineMedium,
                      ),
                      subtitle: Text(
                        workout.description ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: theme.primaryColor),
                          SizedBox(width: 6),
                          starsAsync.when(
                            data: (stars) => Text(
                              '$stars',
                              style: theme.textTheme.bodyMedium,
                            ),
                            loading: () => SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (e, _) => Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
