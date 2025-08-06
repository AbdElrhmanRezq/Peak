import 'package:flutter/material.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workouts",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            CustomIconTextButton(
              title: "Add Workout",
              icon: Icons.add,
              onPressed: () {
                Navigator.of(context).pushNamed('create_workout_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
