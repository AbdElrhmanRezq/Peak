import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  static const id = 'profile_settings_screen';
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final auth = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: CustomAppBar(title: "Settings"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.05,
        ),
        child: ListView(
          children: [
            CustomIconTextButton(
              title: "Edit profile data",
              icon: Icons.edit,
              onPressed: () {
                Navigator.of(context).pushNamed("edit_profile_screen");
              },
            ),
            SizedBox(height: height * 0.01),
            CustomIconTextButton(
              title: "Logout",
              icon: Icons.logout,
              onPressed: () async {
                await auth.logout();

                ref.invalidate(userDataProvider);
                ref.invalidate(isLoadingProvider);
                ref.invalidate(searchedUserProvider);

                ref.invalidate(currentUserProvider);

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('gateway_screen', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
