import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            overlayColor: MaterialStateProperty.all(Colors.transparent),
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

class PeopleList extends StatelessWidget {
  final AsyncSnapshot snapshot;
  const PeopleList({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
                  'public_profile_screen',
                  arguments: {'userId': follower.id},
                );
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    follower.profilePictureUrl ??
                        'assets/images/profile/pro4.jpeg',
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
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
