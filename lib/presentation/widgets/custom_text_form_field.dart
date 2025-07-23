import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    required this.labelText,
    required this.controller,
    required this.validator,
    super.key,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: widget.controller,
        decoration: InputDecoration(
          focusColor: Theme.of(context).primaryColor,
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          fillColor: Colors.white,
        ),
        validator: widget.validator,
      ),
    );
  }
}
