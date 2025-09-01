import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';

class FriendsScreen extends ConsumerWidget {
  static const String id = 'friends_screen';
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userId = arguments['userId'];

    final userRepo = ref.watch(userRepositoryProvider);

    final followersFuture = userRepo.getUserFollowers(userId);
    final followingsFuture = userRepo.getUserFollowings(userId);

    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Friends', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.symmetric(vertical: height * 0.02),
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            indicatorColor: Colors.white,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [Text("Followers"), Text("Following")],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: followersFuture,
              builder: (context, snapshot) => PeopleList(snapshot: snapshot),
            ),
            FutureBuilder(
              future: followingsFuture,
              builder: (context, snapshot) => PeopleList(snapshot: snapshot),
            ),
          ],
        ),
      ),
    );
  }
}

class PeopleList extends ConsumerWidget {
  final AsyncSnapshot snapshot;
  const PeopleList({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final users = snapshot.data ?? [];

    if (users.isEmpty) {
      return Center(
        child: Text(
          "No users found",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.035,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final follower = users[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  'profile_screen',
                  arguments: {'userId': follower.id},
                );
              },
              child: ListTile(
                leading: ClipOval(
                  child: Container(
                    width: width * 0.15,
                    height: height * 0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: follower?.profilePictureUrl != null
                            ? NetworkImage(follower!.profilePictureUrl!)
                            : const AssetImage(
                                    'assets/images/profile/profile.jpeg',
                                  )
                                  as ImageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  follower.name ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  follower.username ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Consumer(
                  builder: (context, ref, _) {
                    final followStatus = ref.watch(
                      followStatusProvider(follower.id),
                    );

                    return followStatus.when(
                      data: (isFollowed) {
                        return IconButton(
                          icon: Icon(
                            isFollowed ? Icons.check : Icons.person_add,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            if (isFollowed) {
                              await userRepo.unfollowUser(
                                currentUser?.id ?? ' ',
                                follower.id,
                              );
                            } else {
                              await userRepo.followUser(
                                currentUser?.id ?? ' ',
                                follower.id,
                              );
                            }

                            // refresh the provider so UI updates
                            ref.invalidate(followStatusProvider(follower.id));
                            ref.invalidate(
                              friendsProvider(currentUser?.id ?? ' '),
                            );
                            ref.invalidate(suggestedFriendsProvider);
                          },
                        );
                      },
                      loading: () => CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                      error: (e, _) => Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
