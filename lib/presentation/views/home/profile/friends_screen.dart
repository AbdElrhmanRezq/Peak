import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/user_data_provider.dart';

class FriendsScreen extends ConsumerWidget {
  static const String id = 'friends_screen';
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final user = ref.watch(userDataProvider);
    final userRepo = ref.watch(userRepositoryProvider);

    return user.when(
      data: (userData) {
        final followers = userRepo.getUserFollowers(userData.id);
        final followings = userRepo.getUserFollowings(userData.id);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text('Friends', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              bottom: TabBar(
                labelPadding: EdgeInsets.symmetric(vertical: height * 0.02),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                indicatorColor: Colors.white,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                tabs: [Text("Followers"), Text("Following")],
              ),
            ),
            body: TabBarView(
              children: [
                FutureBuilder(
                  future: followers,
                  builder: (context, snapshot) {
                    return PeopleList(snapshot: snapshot);
                  },
                ),
                FutureBuilder(
                  future: followings,
                  builder: (context, snapshot) {
                    return PeopleList(snapshot: snapshot);
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

class PeopleList extends StatelessWidget {
  final snapshot;
  const PeopleList({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final follower = snapshot.data![index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  'public_profile_screen',
                  arguments: {'userId': follower.id},
                );
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  child: Image.asset(
                    follower.profilePictureUrl ??
                        'assets/images/profile/pro4.jpeg',
                  ),
                ),
                title: Text(
                  follower.username ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  follower.email ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
