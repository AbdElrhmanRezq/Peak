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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Container(
              height: height * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    text: "Exercises",
                    onPressed: () {
                      setState(() {
                        selectedPage = 'exercises';
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
                        selectedPage = 'Workouts';
                      });
                    },
                    backgroundColor: selectedPage == 'Workouts'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    textColor: selectedPage == 'Workouts'
                        ? Colors.black
                        : Colors.white,
                  ),
                ],
              ),
            ),
          ),

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

          if (selectedPage == 'exercises' && searchQuery.isEmpty)
            BodyPartsGrid(apiRepository: apiRepository)
          else if (selectedPage == 'exercises' && searchQuery.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<ExerciseModel>>(
                future: apiRepository.getSearchedExercises(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data found');
                  }

                  final exercises = snapshot.data!;
                  return CustomExercisesGrid(exercises: exercises);
                },
              ),
            ),

          if (selectedPage == 'Workouts') WorkoutsExplore(),
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data found');
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
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/body_parts/${targets[index]}.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
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
  const WorkoutsExplore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);

    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    WorkoutsRepository workoutsRep = WorkoutsRepository();

    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.03,
        ),
        child: ListView(
          children: [
            Text("Popular Workouts", style: theme.textTheme.headlineMedium),
            FutureBuilder(
              future: workoutsRep.getPopularWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.4),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found');
                }

                final workouts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    WorkoutModel workout = workouts[index];
                    final starsAsync = ref.watch(
                      staredCountProvider(workout.id ?? 0),
                    );
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          'public_workout_screen',
                          arguments: {'workout': workout},
                        );
                      },
                      title: Text(
                        workout.title,
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: Text(workout.description ?? ''),
                      trailing: Row(
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
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
