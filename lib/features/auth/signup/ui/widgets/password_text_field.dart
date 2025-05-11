import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
      controller: _passwordController,
      labelText: "Password",
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        // Matches backend regex: at least 6 chars with uppercase, lowercase, number, and special char
        RegExp passwordRegex =
            RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$');
        if (!passwordRegex.hasMatch(value)) {
          return 'Password must be at least 6 characters with uppercase, lowercase, number, and special character';
        }
        return null;
      },
    );
  }
}
