import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/repository/api_repository.dart';
import 'package:repx/data/services/api_service.dart';
import 'package:repx/data/services/custom_image_getter.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/data/services/custom_cache_manager.dart';
import 'package:repx/presentation/widgets/custom_exercises_grid.dart';

class ExercisesScreen extends StatefulWidget {
  static const id = 'exercises_screen';
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  late final ApiRepository exerciseRepo;

  @override
  void initState() {
    super.initState();
    exerciseRepo = ApiRepository();
  }

  int page = 1;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final bodyPart = args['bodyPart'];

    return Scaffold(
      appBar: CustomAppBar(title: bodyPart?.toUpperCase() as String),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    if (page != 1) {
                      page--;
                    }
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
              Text(page.toString()),
              IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    if (page != 15) {
                      page++;
                    }
                  });
                },
                icon: Icon(Icons.arrow_forward),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<ExerciseModel>>(
              future: exerciseRepo.getTargetBodyPartsExercises(
                bodyPart as String,
                page.toString(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found');
                }

                final exercises = snapshot.data!;
                return CustomExercisesGrid(exercises: exercises);
              },
            ),
          ),
        ],
      ),
    );
  }
}
