import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  const CustomIconTextButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height * 0.1,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ListTile(
            leading: Icon(
              icon,
              size: height * 0.05,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ),
    );
  }
}
