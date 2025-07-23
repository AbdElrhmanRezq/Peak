import 'package:flutter/material.dart';
import 'package:repx/core/theme/app_theme.dart';
import 'package:repx/presentation/views/auth/login_screen.dart';
import 'package:repx/presentation/views/auth/on_board_screen.dart';
import 'package:repx/presentation/views/auth/signup_screen.dart';
import 'package:repx/presentation/views/auth/user_data_screen.dart';
import 'package:repx/presentation/views/gateway/auth_gate.dart';
import 'package:repx/presentation/views/home/profile/add_friend_screen.dart';
import 'package:repx/presentation/views/home/profile/edit_profile_screen.dart';
import 'package:repx/presentation/views/home/home_screen.dart';
import 'package:repx/presentation/views/home/nav_menu.dart';
import 'package:repx/presentation/views/home/profile/friends_screen.dart';
import 'package:repx/presentation/views/home/profile/profile_screen.dart';
import 'package:repx/presentation/views/home/profile/public_profile_screen.dart';
import 'package:repx/presentation/views/initial_screen.dart';
import 'package:repx/presentation/views/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //Supabase connection
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const ProviderScope(child: Repx()));
}

class Repx extends StatelessWidget {
  const Repx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repx',
      theme: appTheme,
      initialRoute: GateWay.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        InitialScreen.id: (context) => const InitialScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        GateWay.id: (context) => const GateWay(),
        OnBoardScreen.id: (context) => const OnBoardScreen(),
        UserDataScreen.id: (context) => const UserDataScreen(),
        NavMenu.id: (context) => const NavMenu(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
        FriendsScreen.id: (context) => const FriendsScreen(),
        PublicProfileScreen.id: (context) => const PublicProfileScreen(),
        AddFriendScreen.id: (context) => AddFriendScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
