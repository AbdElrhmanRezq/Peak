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
    final changedSets = ref.watch(changedSetsProvider);
    final elapsedSeconds = ref.watch(timerProvider); // int

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Summary"),
        leading: IconButton(
          onPressed: () {
            ref.invalidate(changedSetsProvider);
            ref.invalidate(userDataProvider);
            //Don't need to invalidate as the workouts provider data changed
            //ref.invalidate(workoutsProvider);
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
            Text("Completed Sets", style: theme.textTheme.headlineLarge),
            const SizedBox(height: 8),
            Expanded(
              child: changedSets.isEmpty
                  ? const Center(child: Text("No sets recorded"))
                  : ListView.separated(
                      itemCount: changedSets.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final set = changedSets[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text(
                            "${set.weight ?? 0} KG × ${set.reps ?? 0} reps",
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            "Previous: ${set.prev ?? "-"}",
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      },
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
