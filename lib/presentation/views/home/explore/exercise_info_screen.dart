import 'package:flutter/material.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';

class ExerciseInfoScreen extends StatelessWidget {
  static const String id = 'exercise_info_screen';
  const ExerciseInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final ExerciseModel exercise = args['exercise'];
    final image = args['image'];
    return Scaffold(
      appBar: CustomAppBar(title: exercise.name),
      body: ListView(
        children: [
          Image.network(
            image,
            height: height * 0.4,
            width: double.infinity,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * .03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 16),
                Text(
                  "Muscle: ${exercise.target}",
                  style: TextStyle(color: Colors.grey),
                ),

                Text(
                  "Secondary muscles: ${exercise.secondaryMuscles}",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "Difficulty: ${exercise.difficulty.toUpperCase()}",
                  style: TextStyle(
                    color: exercise.difficulty == 'intermediate'
                        ? Colors.amberAccent
                        : exercise.difficulty == 'beginner'
                        ? Colors.lightGreenAccent
                        : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                if (exercise.instructions.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: exercise.instructions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Center(child: Text('${index + 1}')),
                        ),
                        title: Text(
                          exercise.instructions[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  )
                else
                  Text('No instructions available.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
