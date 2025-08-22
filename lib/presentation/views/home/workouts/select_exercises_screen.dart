import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/exercises_provider.dart';
import 'package:repx/data/providers/select_exercise_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/api_repository.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/data/services/custom_image_getter.dart';

//Invalidate the selected exercises in both the selected screen when coming from here
//And the create workout screen
class SelectExercisesScreen extends ConsumerStatefulWidget {
  static const String id = 'select_exercises_screen';
  const SelectExercisesScreen({super.key});

  @override
  ConsumerState<SelectExercisesScreen> createState() =>
      _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends ConsumerState<SelectExercisesScreen> {
  final ApiRepository apiRepository = ApiRepository();
  late Future<List<String>> _bodyPartsFuture;

  @override
  void initState() {
    super.initState();
    _bodyPartsFuture = apiRepository.getTargetBodyParts();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    bool workoutReady = args['workoutReady'] ?? false;
    int workoutId = args['workoutId'] ?? 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final selectedBodyPart = ref.watch(bodyPartProvider);
    final selectedExercises = ref.watch(selectedExercisesProvider);

    WorkoutsRepository workoutRep = WorkoutsRepository();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Select Exercises",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("search_exercise_screen");
            },
            icon: Icon(Icons.search),
          ),
          workoutReady
              ? IconButton(
                  onPressed: () async {
                    await workoutRep.addExercisesToWorkout(
                      workoutId,
                      selectedExercises,
                    );
                    ref.invalidate(selectedExercisesProvider);
                    ref.invalidate(workoutsProvider);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check),
                )
              : Container(),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _bodyPartsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data found');
          }

          final targets = snapshot.data!;
          final exercisesAsync = ref.watch(
            exercisesByBodyPartProvider(selectedBodyPart),
          );
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.15,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: targets.length,
                    itemBuilder: (context, index) {
                      final bodyPart = targets[index];
                      final isSelected = bodyPart == selectedBodyPart;

                      return GestureDetector(
                        onTap: () {
                          ref.read(bodyPartProvider.notifier).state = bodyPart;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : BoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipOval(
                                    child: Container(
                                      width: height * 0.1,
                                      height: height * 0.1,

                                      child: Image.asset(
                                        'assets/images/body_parts/$bodyPart.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                bodyPart.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "Exercises for ${selectedBodyPart.toUpperCase()}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                exercisesAsync.when(
                  data: (exercises) {
                    if (exercises.isEmpty) {
                      return const Text('No exercises found');
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 2.7,
                          ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        final isSelected = selectedExercises.contains(exercise);
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            horizontal: width * 0.02,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              final notifier = ref.read(
                                selectedExercisesProvider.notifier,
                              );
                              if (selectedExercises.contains(exercise)) {
                                notifier.removeExercise(exercise);
                              } else {
                                notifier.addExercise(exercise);
                              }
                            },
                            child: Container(
                              height: height * 0.1,
                              width: width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: selectedExercises.contains(exercise)
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                            child: CachedNetworkImage(
                                              imageUrl: getExerciseGifUrl(
                                                exercise.id,
                                              ),
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
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
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                'exercise_info_screen',
                                                arguments: {
                                                  'exercise': exercise,
                                                  'image': getExerciseGifUrl(
                                                    exercise.id,
                                                  ),
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedExercises.contains(exercise))
                                    Positioned(
                                      right: 6,
                                      top: 6,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
