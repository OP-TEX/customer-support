import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/features/auth/signup/ui/widgets/city_text_field.dart';
import 'package:support/features/auth/signup/ui/widgets/country_text_field.dart';
import 'package:support/features/auth/signup/ui/widgets/phone_text_field.dart';

class SignupStepThree extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController phoneController;

  const SignupStepThree({
    super.key,
    required this.formKey,
    required this.countryController,
    required this.cityController,
    required this.phoneController,
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
                    "3",
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
                "Contact Information",
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
              "Enter your location details for shipping and customer support",
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 30.sp),

          // Form fields
          CountryTextFormField(
            key: Key('register_country_textfield'),
            countryController: countryController,
          ),
          SizedBox(height: 20.sp),
          CityTextFormField(
            key: Key('register_city_textfield'),
            cityController: cityController,
          ),
          SizedBox(height: 20.sp),
          PhoneTextFormField(
            key: Key('register_phone_textfield'),
            phoneController: phoneController,
          ),

          // Tech-themed decoration
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  Icons.location_on_outlined,
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
