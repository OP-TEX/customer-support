import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class CountryTextFormField extends StatelessWidget {
  const CountryTextFormField({
    super.key,
    required TextEditingController countryController,
  }) : _countryController = countryController;

  final TextEditingController _countryController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
      controller: _countryController,
      labelText: "Country",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your country';
        }
        return null;
      },
    );
  }
}
