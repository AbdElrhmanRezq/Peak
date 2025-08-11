import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/services/custom_image_getter.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/presentation/widgets/custom_text_field.dart';

class SearchExercisesScreen extends ConsumerStatefulWidget {
  static const String id = 'search_exercise_screen';
  const SearchExercisesScreen({super.key});

  @override
  ConsumerState<SearchExercisesScreen> createState() =>
      _SearchExercisesScreenState();
}

class _SearchExercisesScreenState extends ConsumerState<SearchExercisesScreen> {
  String _searchText = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedExercises = ref.watch(selectedExercisesProvider);
    final exercisesAsync = ref.watch(searchedExercisesProvider(_searchText));

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: "Search Exercises"),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              controller: _controller,
              labelText: "Search exercises",
              width: width * 0.95,
            ),
          ),

          // 📋 Search results
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                if (exercises.isEmpty) {
                  return const Center(child: Text("No exercises found"));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.7,
                  ),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    final isSelected = selectedExercises.contains(exercise);

                    return GestureDetector(
                      onTap: () {
                        final notifier = ref.read(
                          selectedExercisesProvider.notifier,
                        );
                        if (isSelected) {
                          notifier.removeExercise(exercise);
                        } else {
                          notifier.addExercise(exercise);
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: getExerciseGifUrl(exercise.id),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      exercise.name.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    subtitle: Text(
                                      exercise.bodyPart.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                    0.85,
                                  ), // background for visibility
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
