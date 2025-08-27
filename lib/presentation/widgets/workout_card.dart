import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/workouts_provider.dart';

class WorkoutCard extends ConsumerWidget {
  final WorkoutModel workout;
  final bool choosing;
  final int index;
  final VoidCallback showButtomSheet;
  final String type;
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.index,
    this.choosing = false,
    required this.showButtomSheet,
    this.type = 'personal',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final starsAsync = ref.watch(staredCountProvider(workout.id ?? 0));
    return Container(
      height: height * 0.18,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            type == 'public'
                ? Navigator.of(context).pushNamed(
                    'public_workout_screen',
                    arguments: {'workout': workout},
                  )
                : choosing == false
                ? Navigator.of(
                    context,
                  ).pushNamed('workout_details_screen', arguments: index)
                : Navigator.of(context).pushNamed(
                    'workout_session_screen',
                    arguments: {'workout': workout},
                  );
          },
          child: Container(
            height: height * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: workout.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(workout.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: workout.imageUrl == null
                  ? theme.primaryColor.withOpacity(0.1)
                  : null,
            ),
            child: Stack(
              children: [
                // Dark overlay for readability
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),

                // Title & subtitle (bottom-left)
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      if (workout.description != null)
                        Text(
                          workout.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),

                // Trailing icon (top-right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: type == 'personal'
                      ? IconButton(
                          onPressed: () {
                            showButtomSheet();
                          },
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: theme.primaryColor),
                            SizedBox(width: 10),
                            starsAsync.when(
                              data: (data) => Text(
                                '$data',
                                style: theme.textTheme.bodyMedium,
                              ),
                              error: (error, stack) => Text('Error: $error'),
                              loading: () => CircularProgressIndicator(),
                            ),
                          ],
                        ),
                ),

                // Fallback icon if no image
                if (workout.imageUrl == null)
                  Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: height * 0.05,
                      color: theme.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
