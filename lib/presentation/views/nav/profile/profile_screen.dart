import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_icon_button.dart';
import 'package:repx/presentation/widgets/custom_profile_cards.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class ProfileScreen extends ConsumerWidget {
  static const String id = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final user = ref.watch(userDataProvider);
    final userRepo = ref.watch(userRepositoryProvider);

    return user.when(
      data: (userData) {
        final followers = userRepo.getUserFollowers(userData.id);
        final following = userRepo.getUserFollowings(userData.id);
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
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
                      Positioned(
                        top: 16, // spacing from top
                        right: 16, // spacing from right
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed('profile_settings_screen');
                          },
                          icon: Icon(
                            Icons.settings,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                        Text(
                          userData.name ?? 'N/A',
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                          ),
                          child: Container(
                            height: height * 0.1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  "friends_screen",
                                  arguments: {'userId': userData.id},
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder<List<UserModel>>(
                                        future: followers,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                            );
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder<List<UserModel>>(
                                        future: following,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                            );
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
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed('add_friends_screen');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                    ),
                                    child: Text("Add Friends"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomProfileCards(userData: userData),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
