import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isFilled;
  final double height;
  final double fontSize;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.borderRadius = 32.0,
    this.isFilled = true,
    this.height = 48,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? backgroundColor : Colors.transparent,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isFilled
                ? BorderSide.none
                : BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: textColor),
          ),
        ),
      ),
    );
  }
}
