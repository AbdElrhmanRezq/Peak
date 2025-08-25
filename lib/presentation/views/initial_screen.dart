import 'package:flutter/material.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class InitialScreen extends StatelessWidget {
  static const String id = 'initial_screen';
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/start.gif', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.15,
                  horizontal: width * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NO MORE EXCUSES |",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "DO IT NOW",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.01,
                        bottom: height * 0.02,
                        right: width * 0.15,
                      ),
                      child: Text(
                        "It’s time to take action and become your best self — no more excuses.",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.005,
                        vertical: height * 0.015,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWideButton(
                            text: "Get Started",
                            onPressed: () {
                              Navigator.of(context).pushNamed('login_screen');
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Colors.black,
                            isFilled: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
