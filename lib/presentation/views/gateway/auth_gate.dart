import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/presentation/views/home/nav_menu.dart';
import 'package:repx/presentation/views/initial_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GateWay extends ConsumerWidget {
  static const String id = 'gateway_screen';
  const GateWay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabaseService = Supabase.instance.client;
    return StreamBuilder(
      stream: supabaseService.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final user = snapshot.data;
        if (user?.session == null) {
          return const InitialScreen();
        }
        return const NavMenu();
      },
    );
  }
}
