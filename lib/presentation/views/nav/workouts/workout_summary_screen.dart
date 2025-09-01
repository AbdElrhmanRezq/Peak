import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/sets_provider.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  static const id = 'workout_summary_screen';
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final changedSets = ref.watch(changedSetsProvider);
    final elapsedSeconds = ref.watch(timerProvider);
    final userAsync = ref.watch(userDataProvider);
    final uniqueExerciseIds = changedSets
        .map((set) => set.e_id)
        .toSet()
        .toList();

    final theme = Theme.of(context);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Summary"),
        leading: IconButton(
          onPressed: () async {
            final user = await ref.read(userDataProvider.future);

            ref.invalidate(changedSetsProvider);
            ref.invalidate(userDataProvider);
            //ref.invalidate(workoutsProvider);

            if (context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Workout duration
            Text("Workout Duration", style: theme.textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              _formatSeconds(elapsedSeconds),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 32),

            /// Sets done
            Text("Summary", style: theme.textTheme.headlineLarge),
            const SizedBox(height: 8),
            Expanded(
              child: changedSets.isEmpty
                  ? const Center(child: Text("No sets recorded"))
                  : ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: width * 0.1,
                          ),

                          title: Text(
                            "Exercises",
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            "Played ${uniqueExerciseIds.length.toString()} exercises",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.straighten_sharp,
                            color: Colors.white,
                            size: width * 0.1,
                          ),
                          title: Text(
                            "Sets",
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            "Played ${changedSets.length.toString()} sets",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          leading: Container(
                            width: width * 0.1,
                            height: height * 0.1,
                            child: Image.asset(
                              'assets/icons/burn.png',
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Streak",
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: userAsync.when(
                            data: (user) => Text(
                              "Current streak: ${user.streak} days",
                              style: theme.textTheme.titleMedium,
                            ),
                            loading: () => CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                            error: (e, _) =>
                                Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
            ),

            /// Finish button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final user = await ref.read(userDataProvider.future);

                  ref.invalidate(changedSetsProvider);
                  ref.invalidate(userDataProvider);
                  //ref.invalidate(workoutsProvider);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Finish Workout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// helper function to format seconds into HH:MM:SS
  String _formatSeconds(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
