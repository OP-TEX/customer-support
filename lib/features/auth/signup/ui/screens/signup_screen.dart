import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:support/core/routing/routes.dart';
import 'package:support/core/widgets/custom_rounded_button.dart';
import 'package:support/core/widgets/custom_snackbar.dart';
import 'package:support/core/widgets/loading_overlay.dart';
import 'package:support/features/auth/signup/data/models/register_request_model.dart';
import 'package:support/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:support/features/auth/signup/ui/widgets/signup_step_one.dart';
import 'package:support/features/auth/signup/ui/widgets/signup_step_three.dart';
import 'package:support/features/auth/signup/ui/widgets/signup_step_two.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ViewModel-like state management
  final pageController = PageController();
  int currentPage = 0;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Signup successful",
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(
            context,
            Routes.confirmationScreen,
            arguments: emailController.text,
          );
        } else if (state is RegisterFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return LoadingIndicatorOverlay(
          inAsyncCall: state is RegisterLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              title: SvgPicture.asset(
                width: 0.4.sw,
                theme.brightness == Brightness.light
                    ? 'assets/svgs/Optex_logo_light.svg'
                    : 'assets/svgs/Optex_logo_dark.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
            body: SizedBox(
              height: 1.sh,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background decorative elements
                  Positioned(
                    top: -20,
                    right: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -60,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.sp, horizontal: 24.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section
                        Text(
                          "Sign up",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.sp),
                        RichText(
                          key: Key('register_returnToLogin_textbutton'),
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "or "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, Routes.loginScreen);
                                  },
                                text: "Sign in to Optex",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.sp),

                        // Step indicator
                        Row(
                          children: List.generate(3, (index) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.sp),
                                height: 4.sp,
                                decoration: BoxDecoration(
                                  color: currentPage >= index
                                      ? theme.colorScheme.secondary
                                      : theme.disabledColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2.sp),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 20.sp),

                        // Card container for form steps
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16.sp),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121)
                                          .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(20.sp),
                            child: PageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SignupStepOne(
                                  key: Key('register_step1_form'),
                                  formKey: formKey1,
                                  firstNameController: firstNameController,
                                  lastNameController: lastNameController,
                                ),
                                SignupStepTwo(
                                  key: Key('register_step2_form'),
                                  formKey: formKey2,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                ),
                                SignupStepThree(
                                  key: Key('register_step3_form'),
                                  formKey: formKey3,
                                  countryController: countryController,
                                  cityController: cityController,
                                  phoneController: phoneController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.sp),

                        // Navigation buttons
                        buildNavigationButtons(context, state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage--);
    }
  }

  void nextPage(BuildContext context) {
    if (currentPage == 0 && formKey1.currentState!.validate()) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage++);
    } else if (currentPage == 1 && formKey2.currentState!.validate()) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage++);
    }
  }

  Widget buildNavigationButtons(BuildContext context, RegisterState state) {
    final bool isLoading = state is RegisterLoading;
    final theme = Theme.of(context);

    return Row(
      children: [
        if (currentPage > 0)
          Expanded(
            flex: 2,
            child: customRoundedButton(
              key: Key('register_back_button'),
              borderColor: theme.dividerColor,
              backgroundColor: theme.brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.grey.shade800,
              foregroundColor: theme.textTheme.bodyLarge?.color,
              height: 55.sp,
              onPressed: isLoading ? null : previousPage,
              text: "Back",
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (currentPage > 0) SizedBox(width: 12.sp),
        Expanded(
          flex: 3,
          child: customRoundedButton(
            key: Key('register_continue_button'),
            borderColor: Colors.transparent,
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            height: 55.sp,
            elevation: 2,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            onPressed: isLoading
                ? null
                : () {
                    if (currentPage == 2) {
                      submit(context);
                    } else {
                      nextPage(context);
                    }
                  },
            text: currentPage == 2
                ? (isLoading ? "Submitting..." : "Create Account")
                : (isLoading ? "Loading..." : "Continue"),
          ),
        ),
      ],
    );
  }

  void submit(BuildContext context) {
    if (formKey3.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            RegisterRequestModel(
              firstname: firstNameController.text,
              lastname: lastNameController.text,
              email: emailController.text,
              password: passwordController.text,
              country: countryController.text,
              city: cityController.text,
              phoneNumber: phoneController.text,
            ),
          );
    }
  }
}
