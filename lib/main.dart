import 'package:flutter/material.dart';
import 'package:repx/core/theme/app_theme.dart';
import 'package:repx/views/initial_screen.dart';
import 'package:repx/views/splash/splash_screen.dart';

void main() {
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
