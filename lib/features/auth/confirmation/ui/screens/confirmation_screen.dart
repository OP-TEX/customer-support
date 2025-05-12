import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:support/core/routing/routes.dart';
import 'package:support/core/widgets/custom_rounded_button.dart';
import 'package:support/core/widgets/custom_snackbar.dart';
import 'package:support/core/widgets/loading_overlay.dart';
import 'package:support/features/auth/confirmation/logic/cubit/confirmation_cubit.dart';
import 'package:support/features/auth/confirmation/logic/cubit/confirmation_state.dart';

class ConfirmationScreen extends StatefulWidget {
  final String email;

  const ConfirmationScreen({super.key, required this.email});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final logoPath = brightness == Brightness.light
        ? 'assets/svgs/Optex_logo_light.svg'
        : 'assets/svgs/Optex_logo_dark.svg';

    return BlocConsumer<EmailConfirmationCubit, EmailConfirmationState>(
      listener: (context, state) {
        if (state is EmailConfirmationOtpSent) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );

          // Show OTP field when code is sent
          setState(() {
            _showOtpField = true;
          });
        } else if (state is EmailConfirmationVerified) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );

          // Navigate to home on successful verification
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, Routes.complaintsListScreen);
          });
        } else if (state is EmailConfirmationFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: LoadingIndicatorOverlay(
            inAsyncCall: state is EmailConfirmationLoading,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                title: SvgPicture.asset(
                  width: 0.4.sw,
                  logoPath,
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
                      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 24.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section
                          Text(
                            "Verify Your Email",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 12.sp),

                          // Info card
                          Container(
                            margin: EdgeInsets.only(top: 20.sp),
                            padding: EdgeInsets.all(24.sp),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16.sp),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 121, 121, 121)
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email icon at the top
                                Center(
                                  child: Icon(
                                    Icons.mark_email_unread_rounded,
                                    size: 70.sp,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(height: 20.sp),

                                // Information text
                                Center(
                                  child: Text(
                                    "Confirmation Required",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textTheme.titleLarge?.color,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.sp),
                                Text(
                                  "We've sent a confirmation code to:",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                SizedBox(height: 8.sp),
                                Text(
                                  widget.email,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(height: 20.sp),
                                Text(
                                  "Please check your email and enter the verification code below.",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                
                                // OTP entry field (conditionally shown)
                                if (_showOtpField) ...[
                                  SizedBox(height: 30.sp),
                                  Text(
                                    "Enter verification code:",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  SizedBox(height: 10.sp),
                                  TextFormField(
                                    key: Key('email_otp_textfield'),
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      letterSpacing: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "000000",
                                      hintStyle: TextStyle(
                                        color: theme.hintColor.withOpacity(0.3),
                                        letterSpacing: 10.sp,
                                      ),
                                      filled: true,
                                      fillColor: theme.inputDecorationTheme.fillColor ??
                                          theme.scaffoldBackgroundColor.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.sp),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.sp),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50.sp,
                                    child: customRoundedButton(
                                      key: Key('verify_code_button'),
                                      text: "Verify Code",
                                      backgroundColor: theme.colorScheme.secondary,
                                      borderColor: Colors.transparent,
                                      onPressed: () {
                                        if (_otpController.text.length < 6) {
                                          CustomSnackBar.show(
                                            context: context,
                                            message: "Please enter a valid 6-digit code",
                                            type: SnackBarType.error,
                                          );
                                          return;
                                        }

                                        context.read<EmailConfirmationCubit>().verifyEmail(
                                          email: widget.email,
                                          otp: _otpController.text,
                                        );
                                      },
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                                
                                SizedBox(height: 30.sp),
                                
                                // Resend button
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context.read<EmailConfirmationCubit>()
                                          .resendConfirmationEmail(widget.email);
                                    },
                                    child: Text(
                                      "Didn't receive a code? Resend",
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 20.sp),
                                
                                // Return to login button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.sp,
                                  child: customRoundedButton(
                                    key: Key('back_to_login_button'),
                                    text: "Back to Login",
                                    backgroundColor: theme.brightness == Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade800,
                                    borderColor: theme.dividerColor,
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, Routes.loginScreen);
                                    },
                                    foregroundColor: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tech-themed decoration
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Opacity(
                                opacity: 0.1,
                                child: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 120.sp,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
