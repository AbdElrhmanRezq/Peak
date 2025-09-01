import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/user_data_provider.dart';

import 'package:repx/presentation/widgets/custom_wide_button.dart';

// Example: gender provider to store the selected gender globally
final genderProvider = StateProvider<String>((ref) => 'male');

class GenderScreen extends ConsumerStatefulWidget {
  static const String id = 'gender_screen';
  const GenderScreen({super.key});

  @override
  ConsumerState<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends ConsumerState<GenderScreen> {
  @override
  Widget build(BuildContext context) {
    final gender = ref
        .watch(createdUserProvider)
        .gender; // watch current gender
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.015,
                ),
                child: Text(
                  'Choose your gender',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Column(
                children: [
                  Container(
                    width: width * 0.3,
                    height: height * 0.3,
                    child: CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          ref.read(createdUserProvider.notifier).state = ref
                              .read(createdUserProvider.notifier)
                              .state
                              .copyWith(gender: 'male');
                        },
                        icon: Icon(Icons.male, size: height * 0.07),
                      ),
                      backgroundColor: gender == "male"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                  Container(
                    width: width * 0.3,
                    height: height * 0.3,
                    child: CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          ref.read(createdUserProvider.notifier).state = ref
                              .read(createdUserProvider.notifier)
                              .state
                              .copyWith(gender: 'else');
                        },
                        icon: Icon(Icons.female, size: height * 0.07),
                      ),
                      backgroundColor: gender == "else"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              CustomWideButton(
                backgroundColor: Theme.of(context).primaryColor,
                text: "Next",
                onPressed: () {
                  Navigator.of(context).pushNamed('weight_screen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
