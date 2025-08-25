import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/data/providers/workouts_provider.dart';
import 'package:repx/presentation/widgets/custom_profile_cards.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class PublicProfileScreen extends ConsumerWidget {
  static const String id = 'public_profile_screen';
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = args['userId'];

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    final userRepo = ref.watch(userRepositoryProvider);
    final authRepo = ref.watch(authRepositoryProvider);

    final currentUser = authRepo.currentUser;

    return FutureBuilder<UserModel?>(
      future: userRepo.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(body: Center(child: Text('User not found')));
        }

        final userData = snapshot.data!;
        final followers = userRepo.getUserFollowers(userData.id);
        final following = userRepo.getUserFollowings(userData.id);
        final workoutsAsync = ref.watch(workoutsProvider(userData.id));

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            children: [
              // Cover image
              Stack(
                children: [
                  Container(
                    height: height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: userData.profilePictureUrl != null
                            ? NetworkImage(userData.profilePictureUrl!)
                            : const AssetImage(
                                'assets/images/profile/pro4.jpeg',
                              ),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16, // spacing from top
                    left: 16, // spacing from right
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // User Info
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.username ?? 'N/A',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Wrap(
                      spacing: 4.0, // space between items
                      runSpacing: 4.0, // space between lines
                      children: [
                        Text(
                          userData.username ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '•',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Joined at: ${userData.createdAt?.year ?? 'N/A'}/${userData.createdAt?.month ?? 'N/A'}/${userData.createdAt?.day ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),

                    userData.id != currentUser?.id
                        ? Consumer(
                            builder: (context, ref, _) {
                              final followStatus = ref.watch(
                                followStatusProvider(userId),
                              );

                              return followStatus.when(
                                data: (isFollowed) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                    ),
                                    child: CustomWideButton(
                                      backgroundColor: theme.primaryColor,
                                      text: isFollowed
                                          ? "Remove friend"
                                          : "Add Friend",

                                      onPressed: () async {
                                        if (isFollowed) {
                                          await userRepo.unfollowUser(
                                            currentUser?.id ?? '',
                                            userId,
                                          );
                                        } else {
                                          await userRepo.followUser(
                                            currentUser?.id ?? '',
                                            userId,
                                          );
                                        }

                                        // refresh the provider so UI updates
                                        ref.invalidate(
                                          followStatusProvider(userId),
                                        );
                                      },
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
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  "friends_screen",
                                  arguments: {'userId': userData.id},
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Make here logic
                                  FutureBuilder<List<UserModel>>(
                                    future: followers,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        return Text(
                                          '${snapshot.data?.length ?? 0}',
                                        );
                                      }
                                    },
                                  ),
                                  Text("Followers"),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  "friends_screen",
                                  arguments: {'userId': userData.id},
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<List<UserModel>>(
                                    future: following,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        return Text(
                                          '${snapshot.data?.length ?? 0}',
                                        );
                                      }
                                    },
                                  ),
                                  Text("Following"),
                                ],
                              ),
                            ),
                            workoutsAsync.when(
                              data: (workouts) {
                                if (workouts.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [Text('0'), Text("Workouts")],
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      'user_workouts_screen',
                                      arguments: workouts,
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Text(workouts.length.toString()),
                                      Text("Workouts"),
                                    ],
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
                            ),
                          ],
                        ),
                      ),
                    ),

                    CustomProfileCards(userData: userData),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
