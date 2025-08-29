import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/providers/sets_provider.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';

class WorkoutSessionScreen extends ConsumerWidget {
  static const String id = 'workout_session_screen';
  const WorkoutSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changedSets = ref.watch(changedSetsProvider);
    final exercisesIndex = ref.watch(exercisesIndexProvider);
    final theme = Theme.of(context);

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final workout = args['workout'] as WorkoutModel;

    return Scaffold(
      appBar: _buildAppBar(context, ref, changedSets, theme),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExerciseHeader(workout, exercisesIndex, theme),
          _buildExerciseImage(workout, exercisesIndex),
          _buildExerciseTitle(workout, exercisesIndex, theme),
          Expanded(child: _buildSetsList(workout, exercisesIndex, ref, theme)),
          _buildNavigationButtons(workout, exercisesIndex, ref),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    List<SetModel> changedSets,
    ThemeData theme,
  ) {
    final workoutRep = WorkoutsRepository();

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _showDiscardDialog(context, theme),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (changedSets.isEmpty) return;

            try {
              for (final s in changedSets) {
                s.prev = "${s.weight ?? 0}KG × ${s.reps ?? 0}";
              }
              await workoutRep.updateSets(changedSets);
              ref.invalidate(changedSetsProvider);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Workout saved')));
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Saving failed: $e')));
            }
          },
          child: Text(
            "Finish",
            style: TextStyle(
              color: changedSets.isNotEmpty
                  ? theme.colorScheme.primary
                  : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showDiscardDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text("Discard workout?", style: theme.textTheme.headlineMedium),
        content: Text(
          "Are you sure you want to discard this workout session? All unsaved changes will be lost.",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Discard"),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseHeader(
    WorkoutModel workout,
    int exercisesIndex,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "Exercise ${exercisesIndex + 1} of ${workout.exercises.length}",
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExerciseImage(WorkoutModel workout, int index) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: getExerciseGifUrl(workout.exercises[index].id),
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image, size: 50),
      ),
    );
  }

  Widget _buildExerciseTitle(WorkoutModel workout, int index, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        workout.exercises[index].name,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSetsList(
    WorkoutModel workout,
    int exerciseIndex,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final sets = workout.exercises[exerciseIndex].sets;
    final changedSets = ref.watch(changedSetsProvider);

    return ListView.builder(
      key: ValueKey(exerciseIndex),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      itemCount: sets.length,
      itemBuilder: (context, index) {
        final set = sets[index];

        return Card(
          key: ValueKey("${workout.exercises[exerciseIndex].id}-$index"),
          color: theme.colorScheme.secondary,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNumberField(
                  initial: set.weight?.toString() ?? '',
                  label: "kg",
                  width: 60,
                  onChanged: (val) =>
                      set.weight = double.tryParse(val.trim()) ?? 0,
                  theme: theme,
                ),
                const SizedBox(width: 12),
                _buildNumberField(
                  initial: set.reps?.toString() ?? '',
                  label: "reps",
                  width: 60,
                  onChanged: (val) => set.reps = int.tryParse(val.trim()) ?? 0,
                  theme: theme,
                ),
                if (set.type != "Reps") ...[
                  const SizedBox(width: 12),
                  _buildNumberField(
                    initial: set.repRangeMin?.toString() ?? '',
                    label: "min",
                    width: 50,
                    onChanged: (val) =>
                        set.repRangeMin = int.tryParse(val.trim()) ?? 0,
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _buildNumberField(
                    initial: set.repRangeMax?.toString() ?? '',
                    label: "max",
                    width: 50,
                    onChanged: (val) =>
                        set.repRangeMax = int.tryParse(val.trim()) ?? 0,
                    theme: theme,
                  ),
                ],
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Prev: ${set.prev ?? '-'}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final notifier = ref.read(changedSetsProvider.notifier);
                    if (changedSets.contains(set)) {
                      notifier.removeSet(set);
                    } else {
                      notifier.addSet(set);
                    }
                  },
                  icon: Icon(
                    Icons.check_circle,
                    color: changedSets.contains(set)
                        ? theme.colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberField({
    required String initial,
    required String label,
    required double width,
    required Function(String) onChanged,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(
          hintText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: theme.textTheme.bodyMedium,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationButtons(
    WorkoutModel workout,
    int index,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: index > 0
                ? () => ref.read(exercisesIndexProvider.notifier).state--
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: index < workout.exercises.length - 1
                ? () => ref.read(exercisesIndexProvider.notifier).state++
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
