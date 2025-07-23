import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/presentation/widgets/custom_icon_button.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';
import 'package:repx/presentation/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFriendScreen extends ConsumerWidget {
  static const String id = 'add_friends_screen';
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final textController = TextEditingController();

    final userRepo = ref.watch(userRepositoryProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final foundUser = ref.watch(searchedUserProvider);
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.id;

    search() async {
      ref.read(isLoadingProvider.notifier).state = true;

      try {
        final foundUser = await userRepo.getUserByUsernameOrPhone(
          textController.text,
        );
        ref.read(searchedUserProvider.notifier).state = foundUser;
        print(foundUser);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No User: ${e is AuthException ? e.message : e}'),
          ),
        );
      } finally {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Add Friends"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.03,
        ),
        child: ListView(
          children: [
            CustomIconTextButton(
              title: "Choose From Contacts",
              icon: Icons.contacts,
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Row(
                children: [
                  Text(
                    "Search using Phone/Username",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.7,
                    child: CustomTextField(
                      controller: textController,
                      labelText: "Phone/Username",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      search();
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Text(
                            "Search",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            foundUser == null
                ? Text("No user found")
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          'public_profile_screen',
                          arguments: {'userId': foundUser.id},
                        );
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: Image.asset(
                            foundUser.profilePictureUrl ??
                                'assets/images/profile/pro4.jpeg',
                          ),
                        ),
                        title: Text(
                          foundUser.username ?? 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: FutureBuilder(
                          future: userRepo.isUserFollowed(
                            currentUserId as String,
                            foundUser.id,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              );
                            }

                            final isFollowed = snapshot.data!;
                            return (foundUser.id == currentUserId)
                                ? SizedBox()
                                : CustomIconButton(
                                    icon: isFollowed
                                        ? Icons.person_remove
                                        : Icons.person_add,
                                    onPressed: () async {
                                      if (isFollowed) {
                                        await userRepo.unfollowUser(
                                          currentUserId,
                                          foundUser.id,
                                        );
                                      } else {
                                        await userRepo.followUser(
                                          currentUserId,
                                          foundUser.id,
                                        );
                                      }

                                      // Refresh the state to show the new status
                                      ref.invalidate(searchedUserProvider);
                                    },
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
