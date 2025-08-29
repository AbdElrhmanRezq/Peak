import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/set_model.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/providers/sets_provider.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  static const String id = 'workout_session_screen';
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _countTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _countTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(timerProvider.notifier).state++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final changedSets = ref.watch(changedSetsProvider);
    final exercisesIndex = ref.watch(exercisesIndexProvider);
    final theme = Theme.of(context);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final workout = args['workout'] as WorkoutModel;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, ref, changedSets, theme),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExerciseHeader(workout, exercisesIndex, theme, mediaQuery),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.exercises[exercisesIndex].name.toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
                Text(
                  "Sets: ${workout.exercises[exercisesIndex].sets.length.toString()}",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildSetsList(
              workout,
              exercisesIndex,
              ref,
              theme,
              mediaQuery,
            ),
          ),
          _buildNavigationButtons(
            workout,
            exercisesIndex,
            ref,
            theme,
            width,
            height,
            changedSets,
          ),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
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

              final user = await ref.read(userDataProvider.future);
              await workoutRep.updateStreak(user);

              Navigator.of(
                context,
              ).pushReplacementNamed('workout_summary_screen');

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
    MediaQueryData mediaQuery,
  ) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final paddingTop = mediaQuery.padding.top + kToolbarHeight;

    return Container(
      width: width,
      height: height * 0.4,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: getExerciseGifUrl(workout.exercises[exercisesIndex].id),
            fit: BoxFit.fill,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, size: 50, color: Colors.white),
          ),

          // gradient overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // exercise info
        ],
      ),
    );
  }

  Widget _buildSetsList(
    WorkoutModel workout,
    int exerciseIndex,
    WidgetRef ref,
    ThemeData theme,
    MediaQueryData mediaQuery,
  ) {
    final sets = workout.exercises[exerciseIndex].sets;
    final changedSets = ref.watch(changedSetsProvider);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    return ListView.builder(
      key: ValueKey(exerciseIndex),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.005,
      ),
      itemCount: sets.length,
      itemBuilder: (context, index) {
        final set = sets[index];

        return Card(
          key: ValueKey("${workout.exercises[exerciseIndex].id}-$index"),
          color: theme.colorScheme.secondary,
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
          labelText: label, // ✅ floating label
          labelStyle: theme.textTheme.bodySmall,
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // ✅ rounded rectangle
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
        style: theme.textTheme.bodyMedium,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPrevField({
    required String value,
    required String label,
    required double width,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: value,
        readOnly: true, // ✅ user cannot edit
        decoration: InputDecoration(
          labelText: label, // ✅ floating label (e.g. "Prev")
          labelStyle: theme.textTheme.bodySmall,
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant, // ✅ subtle difference
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7), // ✅ dim text
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
    WorkoutModel workout,
    int index,
    WidgetRef ref,
    ThemeData theme,
    double width,
    double height,
    List<SetModel> changedSets,
  ) {
    final int counter = ref.watch(timerProvider);
    final minutes = (counter ~/ 60).toString().padLeft(2, '0');
    final seconds = (counter % 60).toString().padLeft(2, '0');
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.04,
        horizontal: width * 0.1,
      ),
      child: Container(
        width: width * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: index > 0
                    ? () => ref.read(exercisesIndexProvider.notifier).state--
                    : null,
                icon: const Icon(Icons.arrow_back),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer),
                  Text(
                    "$minutes:$seconds",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFeatures: [
                        const FontFeature.tabularFigures(),
                      ], // keeps numbers aligned
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Sets"),
                  Text(
                    changedSets.length.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFeatures: [
                        const FontFeature.tabularFigures(),
                      ], // keeps numbers aligned
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              IconButton(
                onPressed: index < workout.exercises.length - 1
                    ? () => ref.read(exercisesIndexProvider.notifier).state++
                    : null,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
