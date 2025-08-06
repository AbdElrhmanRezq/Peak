import 'package:flutter/material.dart';
import 'package:repx/data/repository/api_repository.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';

class SelectExercisesScreen extends StatefulWidget {
  static const String id = 'select_exercises_screen';
  const SelectExercisesScreen({super.key});

  @override
  State<SelectExercisesScreen> createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  late ApiRepository apiRepository;
  @override
  void initState() {
    super.initState();
    apiRepository = ApiRepository();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Select Exercises",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("search_exercise_screen");
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<List<String>>(
            future: apiRepository.getTargetBodyParts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data found');
              }

              final targets = snapshot.data!;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.01,
                ),
                child: Container(
                  height: height * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: targets.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).pushNamed(
                          //   'exercises_screen',
                          //   arguments: {'bodyPart': targets[index]},
                          // );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(100),
                              child: Image.asset(
                                'assets/images/body_parts/${targets[index]}.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
