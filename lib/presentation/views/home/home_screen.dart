import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class HomeScreen extends ConsumerWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome ${auth.currentUser?.email ?? 'Guest'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CustomWideButton(
              backgroundColor: Theme.of(context).primaryColor,

              text: "Logout",
              onPressed: () {
                ref.invalidate(userDataProvider); // Add this
                auth.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
