import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/nav_provider.dart';
import 'package:repx/presentation/views/home/explore/explore_screen.dart';
import 'package:repx/presentation/views/home/home_screen.dart';
import 'package:repx/presentation/views/home/profile/profile_screen.dart';
import 'package:repx/presentation/views/home/workouts/workouts_screen.dart';

class NavMenu extends ConsumerWidget {
  static const String id = 'nav_menu';
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenIndex = ref.watch(screenProvider);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final screens = [
      const HomeScreen(),
      const WorkoutsScreen(),
      const ExploreScreen(),
      const ProfileScreen(),
      const Center(child: Text('Notifications Screen')),
    ];

    Widget navDest(IconData icon, int index) {
      return NavigationDestination(
        icon: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Icon(
            icon,
            key: ValueKey<bool>(screenIndex == index),
            color: screenIndex == index
                ? Theme.of(context).iconTheme.color
                : Color(0xFF505050),
          ),
        ),
        label: '',
      );
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        shadowColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: Theme.of(context).scaffoldBackgroundColor,
        height: height * 0.09,
        elevation: 0.5,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: screenIndex,
        onDestinationSelected: (value) {
          ref.read(screenProvider.notifier).state = value;
        },
        destinations: [
          navDest(Icons.home_rounded, 0),
          navDest(Icons.fitness_center_rounded, 1),
          navDest(Icons.explore_rounded, 2),
          navDest(Icons.person_rounded, 3),
          navDest(Icons.notifications_rounded, 4),
        ],
      ),
      body: screens[screenIndex],
    );
  }
}
