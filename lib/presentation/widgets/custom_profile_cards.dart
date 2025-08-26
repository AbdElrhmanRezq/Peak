import 'package:flutter/material.dart';
import 'package:repx/data/models/user_model.dart';

class CustomProfileCards extends StatelessWidget {
  final UserModel userData;
  const CustomProfileCards({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * 0.42,
            height: height * 0.2,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/icons/burn.png',
                  width: width * 0.12,
                  height: height * 0.12,
                  color: Color(0xFFd1fc3e),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(userData.streak.toString()),
                        Text("Streak"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.42,
            height: height * 0.2,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.cake, // Age icon
                        size: height * 0.04,
                        color: theme.primaryColor,
                      ),
                      Text('${userData.age} Y/O'),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.monitor_weight, // Weight icon
                        size: height * 0.04,
                        color: theme.primaryColor,
                      ),
                      Text('${userData.weight} KG'),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.height, // Height icon
                        size: height * 0.04,
                        color: theme.primaryColor,
                      ),
                      Text('${userData.height} CM'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
