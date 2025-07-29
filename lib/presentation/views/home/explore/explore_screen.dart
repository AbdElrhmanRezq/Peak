import 'package:flutter/material.dart';
import 'package:repx/data/services/api_service.dart';
import 'package:repx/presentation/widgets/custom_circular_button.dart';

class ExploreScreen extends StatefulWidget {
  static const id = 'explore_screen_id';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedPage = "exercises";
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final exerciseService = ExerciseApiService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Explore",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Container(
              height: height * 0.04,
              child: Row(
                children: [
                  AppButton(
                    text: "Exercises",
                    onPressed: () {
                      setState(() {
                        selectedPage = 'exercises';
                      });
                    },
                    backgroundColor: selectedPage == 'exercises'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    textColor: selectedPage == 'exercises'
                        ? Colors.black
                        : Colors.white,
                  ),
                  SizedBox(width: width * 0.02),
                  AppButton(
                    text: "Community",
                    onPressed: () {
                      setState(() {
                        selectedPage = 'community';
                      });
                    },
                    backgroundColor: selectedPage == 'community'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    textColor: selectedPage == 'community'
                        ? Colors.black
                        : Colors.white,
                  ),
                ],
              ),
            ),
          ),
          selectedPage == 'exercises'
              ? Expanded(
                  child: FutureBuilder<List<String>>(
                    future: exerciseService.getTargetBodyParts(),
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
                          vertical: height * 0.02,
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: height * 0.015,
                                childAspectRatio: 3 / 4,
                              ),
                          itemCount: targets.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'exercises_screen',
                                  arguments: {'bodyPart': targets[index]},
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/body_parts/${targets[index]}.jpg',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    targets[index].toUpperCase(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
