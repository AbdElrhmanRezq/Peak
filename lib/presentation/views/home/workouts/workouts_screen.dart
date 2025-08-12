import 'package:flutter/material.dart';
import 'package:repx/data/models/workout_model.dart';
import 'package:repx/data/services/supabase_service.dart';
import 'package:repx/presentation/widgets/custom_icon_text_button.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SupabaseService _service = SupabaseService();

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
            FutureBuilder(
              future: _service.getWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final List<WorkoutModel> workouts = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          workouts[index].title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
