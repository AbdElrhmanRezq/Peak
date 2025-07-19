import 'package:flutter/material.dart';
import 'package:repx/core/theme/app_theme.dart';
import 'package:repx/views/initial_screen.dart';
import 'package:repx/views/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //Supabase connection
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://onbmyrlmcowiyyedntuw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9uYm15cmxtY293aXl5ZWRudHV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NDk2OTIsImV4cCI6MjA2NzUyNTY5Mn0.1GHsU3ZgV0zqPAl-drskh8_rnLJAM3SHogqgkkAEP6M',
  );
  runApp(const Repx());
}

class Repx extends StatelessWidget {
  const Repx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repx',
      theme: appTheme,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        InitialScreen.id: (context) => const InitialScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
