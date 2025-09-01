import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/presentation/widgets/workout_card.dart';

class HomeScreen extends ConsumerWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    List<String> motivations = [
      "Push beyond what you thought was possible.",
      "Every rep takes you closer to your best self.",
      "Strength grows where comfort ends.",
      "Your body achieves what your mind believes.",
      "Break barriers, build confidence.",
      "Progress starts with one more step.",
      "Challenge today, conquer tomorrow.",
      "Turn effort into achievement.",
      "Limits exist only to be tested.",
      "Consistency creates transformation.",
    ];

    List<String> gymImages = [
      'assets/images/gym/gym1.jpeg',
      'assets/images/gym/gym2.jpeg',
      'assets/images/gym/gym3.jpeg',
    ];

    int rand = Random().nextInt(10);
    int randImage = Random().nextInt(3);

    final workoutsAsync = ref.watch(popularWorkoutsProvider);

    return userAsync.when(
      data: (user) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  child: ListTile(
                    title: Text(
                      "Welcome, ${user.name}",
                      style: TextStyle(color: theme.primaryColor, fontSize: 24),
                    ),
                    subtitle: Text(
                      motivations[rand],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.01,
                  ),
                  child: Text(
                    "Begin workout",
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Container(
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(gymImages[randImage]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            'workouts_screen',
                            arguments: {'choosing': true},
                          );
                        },
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              height: height * 0.15,
                              'assets/images/workout_start.gif',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.01,
                  ),
                  child: Text(
                    "Popular Workouts",
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                workoutsAsync.when(
                  data: (workouts) {
                    if (workouts.isEmpty) {
                      return Text("No workouts yet.");
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.01,
                      ),
                      child: SizedBox(
                        height: height * 0.18,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: workouts.length > 3 ? 4 : workouts.length,
                          itemBuilder: (context, index) {
                            final workout = workouts[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.005,
                              ),
                              child: Container(
                                width: width * 0.8,
                                child: WorkoutCard(
                                  workout: workout,
                                  index: index,
                                  type: 'public',
                                  showButtomSheet: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: $err',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.01,
                  ),
                  child: Text(
                    "Your Analytics",
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Container(
                    height: height * 0.5,
                    color: theme.colorScheme.secondary,
                    child: Center(
                      child: Text(
                        "Insert analytics later",
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error: $err'),
      ),
    );
  }
}
