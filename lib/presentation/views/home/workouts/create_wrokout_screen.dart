import 'package:flutter/material.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';

class CreateWrokoutScreen extends StatelessWidget {
  static const String id = 'create_workout_screen';
  const CreateWrokoutScreen({super.key});

  void saveWorkout() {}

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Workout",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              saveWorkout();
            },
            icon: Icon(Icons.check_sharp, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              child: TextFormField(
                style: Theme.of(context).textTheme.headlineLarge,
                decoration: InputDecoration(
                  hintText: "Workout title",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            Expanded(child: ListView()),
            CustomWideButton(
              text: "Add Exercises",
              onPressed: () {},
              textColor: Colors.black,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
