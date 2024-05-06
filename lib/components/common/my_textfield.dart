import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    this.hintText,
    this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        labelText: labelText,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        labelStyle: TextStyle(color: Colors.grey[500]),
        floatingLabelStyle: TextStyle(color: Colors.grey[700]),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
      validator: validator, // Добавляем валидатор
    );
  }
}
