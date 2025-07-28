import 'package:flutter/material.dart';
import 'package:repx/data/services/api_service.dart';

class ExercisesScreen extends StatefulWidget {
  static const id = 'exercises_screen_id';
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseService = ExerciseApiService();
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: exerciseService.getTargetMuscles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data found');
          }

          final targets = snapshot.data!;
          return ListView.builder(
            itemCount: targets.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  targets[index].toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
