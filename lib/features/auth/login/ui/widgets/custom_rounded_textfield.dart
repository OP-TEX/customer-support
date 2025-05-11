import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRoundedTextFormField extends StatelessWidget {
  CustomRoundedTextFormField(
      {super.key,
      required TextEditingController controller,
      this.obscureText,
      this.labelText,
      this.validator,
      this.keyboardType})
      : _controller = controller;

  final TextEditingController _controller;

  String? labelText;
  bool? obscureText;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: _controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: labelText ?? "",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color.fromARGB(255, 244, 251, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: validator,
      
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
