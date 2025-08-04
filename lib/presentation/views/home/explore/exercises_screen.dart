import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/repository/api_repository.dart';
import 'package:repx/data/services/api_service.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/data/services/custom_cache_manager.dart';

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

    String getExerciseGifUrl(String exerciseId, {int resolution = 180}) {
      const String apiKey =
          '44c38561c2mshf6844ae156474c6p1d46e9jsn1bc156a74ea9'; //
      return 'https://exercisedb.p.rapidapi.com/image'
          '?exerciseId=$exerciseId'
          '&resolution=$resolution'
          '&rapidapi-key=$apiKey';
    }

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
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: width * 0.02,
                      mainAxisSpacing: height * 0.015,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            'exercise_info_screen',
                            arguments: {
                              'exercise': exercises[index],
                              'image': getExerciseGifUrl(exercises[index].id),
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  cacheManager: exerciseImageCacheManager,
                                  imageUrl: getExerciseGifUrl(
                                    exercises[index].id,
                                  ),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              exercises[index].name.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Target: ${exercises[index].target.toUpperCase()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              exercises[index].difficulty.toUpperCase(),
                              style: TextStyle(
                                color:
                                    exercises[index].difficulty ==
                                        'intermediate'
                                    ? Colors.amberAccent
                                    : exercises[index].difficulty == 'beginner'
                                    ? Colors.lightGreenAccent
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
