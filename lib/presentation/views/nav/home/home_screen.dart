import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

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

    int rand = Random().nextInt(10);

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
                    color: theme.colorScheme.secondary,
                    child: Center(
                      child: Container(
                        width: width * 0.8,
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.scaffoldBackgroundColor,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Today's workout",
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Workout",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  height: height * 0.15,
                                  width: width * 0.35,
                                  'assets/images/start.gif',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
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
