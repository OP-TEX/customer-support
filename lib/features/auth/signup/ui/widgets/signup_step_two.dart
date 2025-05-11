import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/features/auth/signup/ui/widgets/email_text_field.dart';
import 'package:support/features/auth/signup/ui/widgets/password_text_field.dart';

class SignupStepTwo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupStepTwo({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
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
                    "2",
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
                "Account Information",
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
              "Create your login credentials for the Optex platform",
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 30.sp),

          // Form fields
          EmailTextFormField(
            key: Key('register_email_textfield'),
            emailController: emailController,
          ),
          SizedBox(height: 20.sp),
          PasswordTextFormField(
            key: Key('register_password_textfield'),
            passwordController: passwordController,
          ),
          SizedBox(height: 12.sp),

          // Password hint
          Padding(
            padding: EdgeInsets.only(left: 8.sp),
            child: Text(
              "Password must be at least 8 characters with letters, numbers, and symbols",
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ),

          // Tech-themed decoration
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  Icons.security,
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
