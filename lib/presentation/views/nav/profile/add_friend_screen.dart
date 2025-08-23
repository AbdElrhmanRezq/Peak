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
    final foundUsers = ref.watch(searchedUserProvider);
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.id;

    search() async {
      ref.read(isLoadingProvider.notifier).state = true;

      try {
        final foundUsers = await userRepo.getUsersByName(textController.text);
        ref.read(searchedUserProvider.notifier).state = foundUsers;
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
                    "Search using Username",
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
                      labelText: "Username",
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
            foundUsers == []
                ? Text("No users found")
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: Container(
                      height: height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: foundUsers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.002,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),

                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    'public_profile_screen',
                                    arguments: {
                                      'userId': foundUsers[index]?.id,
                                    },
                                  );
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    100,
                                  ),
                                  child: Image.asset(
                                    foundUsers[index]?.profilePictureUrl ??
                                        'assets/images/profile/pro4.jpeg',
                                  ),
                                ),
                                title: Text(
                                  foundUsers[index]?.name ?? 'N/A',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  foundUsers[index]?.username ?? 'N/A',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: foundUsers[index]?.id == currentUserId
                                    ? const SizedBox()
                                    : Consumer(
                                        builder: (context, ref, _) {
                                          final followStatus = ref.watch(
                                            followStatusProvider(
                                              foundUsers[index]!.id,
                                            ),
                                          );

                                          return followStatus.when(
                                            data: (isFollowed) {
                                              return IconButton(
                                                icon: Icon(
                                                  isFollowed
                                                      ? Icons.done_outline_sharp
                                                      : Icons
                                                            .group_add_outlined,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                                onPressed: () async {
                                                  if (isFollowed) {
                                                    await userRepo.unfollowUser(
                                                      currentUserId!,
                                                      foundUsers[index]!.id,
                                                    );
                                                  } else {
                                                    await userRepo.followUser(
                                                      currentUserId!,
                                                      foundUsers[index]!.id,
                                                    );
                                                  }

                                                  // refresh the provider so UI updates
                                                  ref.invalidate(
                                                    followStatusProvider(
                                                      foundUsers[index]!.id,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
