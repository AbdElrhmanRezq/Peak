import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';
import 'package:repx/presentation/widgets/scroller.dart';

class WeightScreen extends ConsumerWidget {
  static const String id = 'weight_screen';
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(createdUserProvider); // watch current gender
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
                  'Choose your weight (KG)',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),

              Expanded(
                child: Scroller(
                  value: user.weight ?? 50,
                  type: 'weight',
                  onChanged: (value) {
                    ref.read(createdUserProvider.notifier).update((state) {
                      return state.copyWith(weight: value);
                    });
                  },
                ),
              ),
              CustomWideButton(
                backgroundColor: Theme.of(context).primaryColor,
                text: "Next",
                onPressed: () {
                  Navigator.of(context).pushNamed('height_screen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
