import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/features/auth/signup/ui/widgets/firstname_text_field.dart';
import 'package:support/features/auth/signup/ui/widgets/lastname_text_field.dart';

class SignupStepOne extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const SignupStepOne({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: ListView(
        children: [
          // Step header
          Row(
            children: [
              Container(
                width: 30.sp,
                height: 30.sp,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.sp),
              Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Padding(
            padding: EdgeInsets.only(left: 40.sp),
            child: Text(
              "Please enter your name as it appears on your official documents",
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 30.sp),

          // Form fields
          FirstnameTextFormField(
            key: Key('register_firstname_textfield'),
            firstNameController: firstNameController,
          ),
          SizedBox(height: 20.sp),
          LastnameTextFormField(
            key: Key('register_lastname_textfield'),
            lastNameController: lastNameController,
          ),

          // Tech-themed decoration
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  Icons.person_outline,
                  size: 120.sp,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
