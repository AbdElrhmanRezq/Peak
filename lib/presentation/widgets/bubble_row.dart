import 'package:flutter/material.dart';
import 'package:repx/data/models/user_model.dart';

class BubbleRow extends StatelessWidget {
  final List<UserModel> friends;
  const BubbleRow({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: friends[0].profilePictureUrl != null
              ? NetworkImage(friends[0].profilePictureUrl ?? '')
              : AssetImage('assets/images/profile/pro4.jpeg') as ImageProvider,
        ),
        if (friends.length > 1)
          CircleAvatar(
            backgroundImage: friends[1].profilePictureUrl != null
                ? NetworkImage(friends[1].profilePictureUrl ?? '')
                : AssetImage('assets/images/profile/pro4.jpeg')
                      as ImageProvider,
          ),
        if (friends.length > 2)
          CircleAvatar(
            backgroundImage: friends[2].profilePictureUrl != null
                ? NetworkImage(friends[2].profilePictureUrl ?? '')
                : AssetImage('assets/images/profile/pro4.jpeg')
                      as ImageProvider,
          ),
        if (friends.length > 3)
          CircleAvatar(
            backgroundImage: friends[3].profilePictureUrl != null
                ? NetworkImage(friends[3].profilePictureUrl ?? '')
                : AssetImage('assets/images/profile/pro4.jpeg')
                      as ImageProvider,
          ),
        if (friends.length > 4)
          CircleAvatar(
            backgroundColor: theme.primaryColor,
            child: Text("+${friends.length - 4}"),
          ),
      ],
    );
  }
}
