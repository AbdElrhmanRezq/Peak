import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';
import 'package:repx/presentation/widgets/scroller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgeScreen extends ConsumerWidget {
  static const String id = 'age_screen';
  const AgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(createdUserProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Future<void> processData() async {
      final auth = ref.read(authRepositoryProvider);
      final createdUser = ref.read(createdUserProvider);

      try {
        await auth.createUser(createdUser);
        //await auth.login(createdUser.email, ref.read(passwordProvider));
        //ref.invalidate(passwordProvider);
        ref.invalidate(userDataProvider);
        ref.invalidate(currentUserProvider);
        Navigator.of(context).pushNamedAndRemoveUntil(
          'nav_menu',
          (route) => false, // remove all previous routes
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup failed: ${e is AuthException ? e.message : e}',
            ),
          ),
        );
      } finally {
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.015,
                ),
                child: Text(
                  'Choose your age',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),

              Expanded(
                child: Scroller(
                  value: user.age ?? 18,
                  type: 'age',
                  onChanged: (value) {
                    ref.read(createdUserProvider.notifier).update((state) {
                      return state.copyWith(age: value);
                    });
                  },
                ),
              ),
              CustomWideButton(
                backgroundColor: Theme.of(context).primaryColor,
                text: "Start",
                onPressed: () async {
                  await processData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
