import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/presentation/widgets/bubble_row.dart';
import 'package:repx/presentation/widgets/workout_card.dart';

class ProfileScreen extends ConsumerWidget {
  static const String id = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userId = args != null ? args['userId'] as String? : null;

    final authRepo = ref.watch(authRepositoryProvider);

    final currentUser = authRepo.currentUser;

    final userAsync = ref.watch(profileUserProvider(userId));

    final userRepo = ref.watch(userRepositoryProvider);

    return userAsync.when(
      data: (userData) {
        final friendsAsync = ref.watch(friendsProvider(userData.id));
        final workoutsAsync = ref.watch(workoutsProvider(userData.id));

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: userData.profilePictureUrl != null
                            ? NetworkImage(
                                '${userData.profilePictureUrl!}?v=${DateTime.now().millisecondsSinceEpoch}',
                              )
                            : const AssetImage(
                                'assets/images/profile/pro4.jpeg',
                              ),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  currentUser?.id == userData.id
                      ? Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed('profile_settings_screen');
                            },
                            icon: const Icon(
                              Icons.settings,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(),
                  currentUser?.id != userData.id
                      ? Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              userData.name ?? 'N/A',
                              style: theme.textTheme.headlineLarge,
                            ),
                            Wrap(
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children: [
                                Text(
                                  userData.username ?? '',
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text('•', style: theme.textTheme.titleMedium),
                                Text(
                                  'Joined at: ${userData.createdAt?.year ?? 'N/A'}/${userData.createdAt?.month ?? 'N/A'}/${userData.createdAt?.day ?? 'N/A'}',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        currentUser?.id != userData.id
                            ? Consumer(
                                builder: (context, ref, _) {
                                  final followStatus = ref.watch(
                                    followStatusProvider(userId ?? ''),
                                  );

                                  return followStatus.when(
                                    data: (isFollowed) {
                                      return CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        child: IconButton(
                                          onPressed: () async {
                                            if (isFollowed) {
                                              await userRepo.unfollowUser(
                                                currentUser?.id ?? '',
                                                userId ?? '',
                                              );
                                            } else {
                                              await userRepo.followUser(
                                                currentUser?.id ?? '',
                                                userId ?? ' ',
                                              );
                                            }

                                            ref.invalidate(
                                              followStatusProvider(
                                                userId ?? ' ',
                                              ),
                                            );
                                            ref.invalidate(
                                              friendsProvider(
                                                currentUser?.id ?? ' ',
                                              ),
                                            );
                                          },
                                          icon: isFollowed
                                              ? Icon(Icons.check)
                                              : Icon(Icons.person_add),
                                        ),
                                      );
                                    },
                                    loading: () => CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    error: (e, _) =>
                                        Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                            : SizedBox(),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      child: Container(
                        height: height * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  userData.streak.toString(),
                                  style: TextStyle(
                                    color: userData.streak > 0
                                        ? theme.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/burn.png',
                                      color: userData.streak > 0
                                          ? theme.primaryColor
                                          : Colors.white,
                                      height: height * 0.03,
                                    ),
                                    Text(
                                      " Streak",
                                      style: TextStyle(
                                        color: userData.streak > 0
                                            ? theme.primaryColor
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: theme.scaffoldBackgroundColor,
                              width: width * 0.01,
                              indent: 8,
                              endIndent: 8,
                              radius: BorderRadius.circular(12),
                            ),
                            workoutsAsync.when(
                              data: (workouts) => Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(workouts.length.toString()),
                                  Text(
                                    "Workouts",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: Text(
                        "Friends",
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    friendsAsync.when(
                      data: (friends) {
                        if (friends.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('0'), Text("Friends")],
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              'friends_screen',
                              arguments: {'userId': userData.id},
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BubbleRow(friends: friends),
                                currentUser?.id == userData.id
                                    ? CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pushNamed("add_friends_screen");
                                          },
                                          icon: Icon(Icons.person_add),
                                        ),
                                      )
                                    : SizedBox(),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$err'),
                            currentUser?.id == userData.id
                                ? CircleAvatar(
                                    backgroundColor: theme.primaryColor,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("add_friends_screen");
                                      },
                                      icon: Icon(Icons.person_add),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: Text(
                        "Workouts",
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    workoutsAsync.when(
                      data: (workouts) {
                        if (workouts.isEmpty) {
                          return Text("No workouts yet.");
                        }

                        return SizedBox(
                          height: height * 0.18,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: workouts.length > 3
                                ? 4
                                : workouts.length,
                            itemBuilder: (context, index) {
                              final workout = workouts[index];
                              return index == 3
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              'user_workouts_screen',
                                              arguments: workouts,
                                            );
                                          },
                                          icon: Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    )
                                  : Padding(
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          Center(child: CircularProgressIndicator(color: theme.primaryColor)),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
