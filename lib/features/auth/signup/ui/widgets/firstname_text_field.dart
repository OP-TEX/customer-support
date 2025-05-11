import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class FirstnameTextFormField extends StatelessWidget {
  const FirstnameTextFormField({
    super.key,
    required TextEditingController firstNameController,
  }) : _firstNameController = firstNameController;

  final TextEditingController _firstNameController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
        controller: _firstNameController,
        labelText: "First Name",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your first name';
          }
          return null;
        });
  }
}
