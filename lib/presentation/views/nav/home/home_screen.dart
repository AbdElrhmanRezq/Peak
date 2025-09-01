import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
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
    final suggestedFriendsAsync = ref.watch(suggestedFriendsProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);

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
                  loading: () => Center(
                    child: Container(
                      height: height * 0.18,
                      alignment: Alignment.center, // centers child
                      child: CircularProgressIndicator(),
                    ),
                  ),

                  error: (err, stack) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: height * 0.01,
                    ),
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
                    "People to follow",
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                suggestedFriendsAsync.when(
                  data: (suggestedFriends) {
                    return Container(
                      height: height * 0.25,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.01,
                        ),
                        child: ListView.builder(
                          itemCount: suggestedFriends.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final friend = suggestedFriends[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              child: Container(
                                width: width * 0.4,
                                height: height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(
                                  //   color: Colors.white,
                                  //   width: 2,
                                  // ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Container(
                                          height: height * 0.4,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  friend.profilePictureUrl !=
                                                      null
                                                  ? NetworkImage(
                                                      '${friend.profilePictureUrl!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                                    )
                                                  : const AssetImage(
                                                      'assets/images/profile/pro4.jpeg',
                                                    ),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
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
                                          friend.name?.toUpperCase() ?? 'N/A',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        subtitle: Text(
                                          friend.username?.toUpperCase() ??
                                              'N/A',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                        trailing: Consumer(
                                          builder: (context, ref, _) {
                                            final followStatus = ref.watch(
                                              followStatusProvider(friend.id),
                                            );

                                            return followStatus.when(
                                              data: (isFollowed) {
                                                return IconButton(
                                                  icon: Icon(
                                                    isFollowed
                                                        ? Icons.check
                                                        : Icons.person_add,
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                  ),
                                                  onPressed: () async {
                                                    if (isFollowed) {
                                                      await userRepo
                                                          .unfollowUser(
                                                            currentUser?.id ??
                                                                '',
                                                            friend.id,
                                                          );
                                                    } else {
                                                      await userRepo.followUser(
                                                        currentUser?.id ?? '',
                                                        friend.id,
                                                      );
                                                    }

                                                    // refresh the provider so UI updates
                                                    ref.invalidate(
                                                      followStatusProvider(
                                                        friend.id,
                                                      ),
                                                    );
                                                    ref.invalidate(
                                                      friendsProvider(
                                                        currentUser?.id ?? ' ',
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              loading: () =>
                                                  CircularProgressIndicator(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                  ),
                                              error: (e, _) => Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            'profile_screen',
                                            arguments: {'userId': friend.id},
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: width * 0.06,
                //     vertical: height * 0.01,
                //   ),
                //   child: Text(
                //     "Your Analytics",
                //     style: theme.textTheme.headlineMedium,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: height * 0.02),
                //   child: Container(
                //     height: height * 0.5,
                //     color: theme.colorScheme.secondary,
                //     child: Center(
                //       child: Text(
                //         "Insert analytics later",
                //         style: theme.textTheme.headlineMedium,
                //       ),
                //     ),
                //   ),
                // ),
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
