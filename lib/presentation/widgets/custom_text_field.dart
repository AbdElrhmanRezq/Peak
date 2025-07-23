import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;

  const CustomTextField({super.key, this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.transparent,
        filled: true, // Needed to apply fillColor
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // sharp edges
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }
}
