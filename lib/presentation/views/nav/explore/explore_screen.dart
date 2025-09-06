import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/data/repository/api_repository.dart';
import 'package:repx/data/repository/workouts_repository.dart';
import 'package:repx/presentation/widgets/custom_circular_button.dart';
import 'package:repx/presentation/widgets/custom_exercises_grid.dart';
import 'package:repx/presentation/widgets/custom_text_field.dart';
import 'package:repx/presentation/widgets/workout_card.dart';

class ExploreScreen extends StatefulWidget {
  static const id = 'explore_screen_id';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedPage = "exercises";
  late ApiRepository apiRepository;
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    apiRepository = ApiRepository();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Explore",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top navigation buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: SizedBox(
              height: height * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    text: "Exercises",
                    onPressed: () {
                      setState(() {
                        selectedPage = 'exercises';
                        searchController.clear();
                        searchQuery = '';
                      });
                    },
                    backgroundColor: selectedPage == 'exercises'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    textColor: selectedPage == 'exercises'
                        ? Colors.black
                        : Colors.white,
                  ),
                  SizedBox(width: width * 0.02),
                  AppButton(
                    text: "Workouts",
                    onPressed: () {
                      setState(() {
                        selectedPage = 'workouts';
                        searchController.clear();
                        searchQuery = '';
                      });
                    },
                    backgroundColor: selectedPage == 'workouts'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    textColor: selectedPage == 'workouts'
                        ? Colors.black
                        : Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Search bar for Exercises
          if (selectedPage == 'exercises')
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.015,
              ),
              child: CustomTextField(
                width: width * 0.9,
                labelText: "Search Exercise",
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              ),
            ),

          // Search bar for Workouts
          if (selectedPage == 'workouts')
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.015,
              ),
              child: CustomTextField(
                width: width * 0.9,
                labelText: "Search Workouts",
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              ),
            ),

          // Exercises section
          if (selectedPage == 'exercises' && searchQuery.isEmpty)
            BodyPartsGrid(apiRepository: apiRepository)
          else if (selectedPage == 'exercises' && searchQuery.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<ExerciseModel>>(
                future: apiRepository.getSearchedExercises(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No exercises found'));
                  }
                  return CustomExercisesGrid(exercises: snapshot.data!);
                },
              ),
            ),

          // Workouts section
          if (selectedPage == 'workouts')
            WorkoutsExplore(searchQuery: searchQuery),
        ],
      ),
    );
  }
}

class BodyPartsGrid extends StatelessWidget {
  final ApiRepository apiRepository;
  const BodyPartsGrid({required this.apiRepository, super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Expanded(
      child: FutureBuilder<List<String>>(
        future: apiRepository.getTargetBodyParts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No body parts found'));
          }

          final targets = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.02,
                mainAxisSpacing: height * 0.015,
                childAspectRatio: 3 / 4,
              ),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      'exercises_screen',
                      arguments: {'bodyPart': targets[index]},
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/body_parts/${targets[index]}.jpg',
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        targets[index].toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WorkoutsExplore extends ConsumerWidget {
  final String searchQuery;
  const WorkoutsExplore({required this.searchQuery, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    WorkoutsRepository workoutsRep = WorkoutsRepository();

    final workoutsAsync = ref.watch(popularWorkoutsProvider);

    if (searchQuery.isNotEmpty) {
      final searchedWorkoutsAsync = ref.watch(
        searchedWorkoutsProvider(searchQuery),
      );
      return Expanded(
        child: searchedWorkoutsAsync.when(
          data: (workouts) {
            if (workouts.isEmpty) {
              return const Center(child: Text("No workouts found"));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: ListView(
          children: [
            Text("Popular Workouts", style: theme.textTheme.headlineMedium),
            workoutsAsync.when(
              data: (workouts) {
                if (workouts.isEmpty) {
                  return const Text('No workouts found');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
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
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.4),
                  child: const CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }
}
