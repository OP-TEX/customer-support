import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
        controller: _emailController,
        labelText: "Email",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        });
  }
}
