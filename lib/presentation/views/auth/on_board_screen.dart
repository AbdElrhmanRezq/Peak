import 'package:flutter/material.dart';
import 'package:repx/presentation/widgets/custom_on_board_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  static const String id = 'on_board_screen';
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _controller = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  if (index == 3) {
                    setState(() {
                      lastPage = true;
                    });
                  } else {
                    setState(() {
                      lastPage = false;
                    });
                  }
                },
                children: [
                  // Add your onboarding pages here
                  CustomOnBoardPage(
                    title: "Start Your Fitness Journey",
                    description:
                        "Take the first step towards a healthier, stronger you.",
                    imagePath: "assets/images/people/initial_screen.png",
                  ),

                  CustomOnBoardPage(
                    title: "Track Every Workout",
                    description:
                        "Monitor your progress and stay consistent with smart tracking tools.",
                    imagePath: "assets/images/people/initial_screen.png",
                  ),

                  CustomOnBoardPage(
                    title: "Discover New Exercises",
                    description:
                        "Explore a variety of exercises tailored to your goals and skill level.",
                    imagePath: "assets/images/people/initial_screen.png",
                  ),

                  CustomOnBoardPage(
                    title: "Connect With Friends",
                    description:
                        "Stay motivated by sharing progress and challenges with your fitness circle.",
                    imagePath: "assets/images/people/initial_screen.png",
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  lastPage
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            // Handle start button press
                          },
                          child: const Icon(Icons.sports_gymnastics),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Icon(Icons.arrow_forward),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
