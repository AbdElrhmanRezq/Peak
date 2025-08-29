import 'package:flutter/material.dart';
import 'package:repx/data/models/user_model.dart';

class CustomUserPhoto extends StatelessWidget {
  final UserModel user;
  const CustomUserPhoto({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: user.profilePictureUrl != null
              ? NetworkImage(user.profilePictureUrl!)
              : const AssetImage('assets/images/profile/pro4.jpeg')
                    as ImageProvider,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
