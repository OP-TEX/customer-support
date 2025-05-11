import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class CityTextFormField extends StatelessWidget {
  const CityTextFormField({
    super.key,
    required TextEditingController cityController,
  }) : _cityController = cityController;

  final TextEditingController _cityController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
      controller: _cityController,
      labelText: "City",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your city';
        }
        return null;
      },
    );
  }
}
