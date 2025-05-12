import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:support/core/routing/routes.dart';
import 'package:support/core/widgets/custom_divider_text.dart';
import 'package:support/core/widgets/custom_rounded_button.dart';
import 'package:support/core/widgets/custom_snackbar.dart';
import 'package:support/core/widgets/loading_overlay.dart';
import 'package:support/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:support/features/auth/login/logic/cubit/login_state.dart';
import 'package:support/features/auth/signup/ui/widgets/email_text_field.dart';
import 'package:support/features/auth/signup/ui/widgets/password_text_field.dart';
import 'package:support/core/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  void _onLoginSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      Routes.mainScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
        } else if (state is LoginSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Login successful",
            type: SnackBarType.success,
          );
          _onLoginSuccess(context);
        } else if (state is LoginFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        } else if (state is LoginEmailNotConfirmed) {
          // Navigate to email confirmation screen
          Navigator.pushReplacementNamed(
            context,
            Routes.confirmationScreen,
            arguments: state.email,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
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
            child: LoadingIndicatorOverlay(
              inAsyncCall: state is LoginLoading,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient elements for tech feel
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.sp, horizontal: 24.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section
                          Text(
                            "Sign in",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            key: Key("joinOptex"),
                            text: TextSpan(
                              children: [
                                TextSpan(text: "or "),
                                TextSpan(
                                  semanticsLabel: "joinOptex",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, Routes.signUpScreen);
                                    },
                                  text: "Join Optex",
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
                          SizedBox(height: 30.sp),

                          // Login form card
                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16.sp),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121)
                                          .withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(20.sp),
                            child: Column(
                              children: [
                                // Google sign-in button
                                customRoundedButton(
                                  width: double.infinity,
                                  height: 55.sp,
                                  foregroundColor:
                                      theme.textTheme.bodyLarge?.color,
                                  borderColor: theme.dividerColor,
                                  text: "Sign in with Google",
                                  backgroundColor: Colors.transparent,
                                  icon: FontAwesomeIcons.google,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, Routes.complaintsListScreen);
                                  },
                                ),
                                SizedBox(height: 25.sp),
                                customDividerWithText(
                                    child: Text("or continue with email")),
                                SizedBox(height: 25.sp),

                                // Email and password form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EmailTextFormField(
                                        key: Key("login_email_textfield"),
                                        emailController: _emailController,
                                      ),
                                      SizedBox(height: 20.sp),
                                      PasswordTextFormField(
                                        key: Key("login_password_textfield"),
                                        passwordController: _passwordController,
                                      ),
                                      SizedBox(height: 15.sp),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          key: Key(
                                              "login_forgotpassword_textButton"),
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                Routes.forgotPasswordScreen);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              key: Key(
                                                  "login_forgotpassword_text"),
                                              "Forgot Password?",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30.sp),

                                      // Login button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 55.sp,
                                        child: customRoundedButton(
                                          key: Key("login_continue_button"),
                                          text: "Sign In",
                                          backgroundColor:
                                              theme.colorScheme.secondary,
                                          borderColor: Colors.transparent,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.sp),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final email =
                                                  _emailController.text;
                                              final password =
                                                  _passwordController.text;
                                              context
                                                  .read<LoginCubit>()
                                                  .login(email, password);
                                            }
                                          },
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}
