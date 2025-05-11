import 'package:flutter/material.dart';
import 'package:support/features/auth/login/ui/widgets/custom_rounded_textfield.dart';

class PhoneTextFormField extends StatelessWidget {
  const PhoneTextFormField({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
      controller: _phoneController,
      labelText: "Phone Number",
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        // Matches backend regex: must start with 010, 011, 012, or 015 and have exactly 11 digits
        RegExp phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Phone must start with 010, 011, 012, or 015 followed by 8 digits';
        }
        return null;
      },
    );
  }
}
