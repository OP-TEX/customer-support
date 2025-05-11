
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:support/core/widgets/custom_snackbar.dart';
import 'package:support/features/auth/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:support/features/auth/forgetpassword/logic/cubit/forget_password_state.dart';

class ForgotPasswordSteps extends StatefulWidget {
  const ForgotPasswordSteps({Key? key}) : super(key: key);

  @override
  _ForgotPasswordStepsState createState() => _ForgotPasswordStepsState();
}

class _ForgotPasswordStepsState extends State<ForgotPasswordSteps> {
  int _currentStep = 0;
  String email = '';
  String forgotToken = '';
  String resetToken = '';

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = Theme.of(context).brightness;
    final logoPath = brightness == Brightness.light
        ? 'assets/svgs/Optex_logo_light.svg'
        : 'assets/svgs/Optex_logo_dark.svg';

    return BlocConsumer<ForgetPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordEmailSent) {
          forgotToken = state.forgotToken;
          setState(() => _currentStep = 1);
        } else if (state is ForgotPasswordOtpVerified) {
          resetToken = state.resetToken;
          setState(() => _currentStep = 2);
        } else if (state is ForgotPasswordSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Password reset successfully!",
            type: SnackBarType.success,
          );
          Navigator.pop(context);
        } else if (state is ForgotPasswordError) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: SvgPicture.asset(
              logoPath,
              width: 0.4.sw,
              fit: BoxFit.fitWidth,
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Stack(
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
                padding:
                    EdgeInsets.symmetric(vertical: 20.sp, horizontal: 24.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Reset Password",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      "Follow the steps to reset your password",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color:
                            theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
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
                              color: _currentStep >= index
                                  ? theme.colorScheme.secondary
                                  : theme.disabledColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2.sp),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20.sp),

                    // Card container for current step
                    Expanded(
                      child: Container(
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
                        padding: EdgeInsets.all(24.sp),
                        child: SingleChildScrollView(
                          child: buildCurrentStep(context, state),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.sp),

                    // Action buttons
                    buildActionButtons(context, state),
                  ],
                ),
              ),

              // Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCurrentStep(BuildContext context, ForgotPasswordState state) {
    final theme = Theme.of(context);

    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Enter Your Email",
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
                "We'll send a verification code to this email",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 30.sp),

            // Email field
            TextFormField(
              key: Key('forgotPassword_email_textfield'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email_outlined,
                    color: theme.colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide:
                      BorderSide(color: theme.colorScheme.secondary, width: 2),
                ),
              ),
            ),

            // Tech-themed decoration
            SizedBox(height: 50.sp),
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: 120.sp,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Enter Verification Code",
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
                "Check your email for the 6-digit verification code",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 30.sp),

            // OTP field
            TextFormField(
              key: Key('forgotPassword_otp_textfield'),
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: TextStyle(
                letterSpacing: 15.sp,
                fontSize: 24.sp,
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

            SizedBox(height: 16.sp),
            Center(
              child: TextButton(
                onPressed: () {
                  // Here you would add resend functionality
                  CustomSnackBar.show(
                    context: context,
                    message: "Resending code...",
                    type: SnackBarType.info,
                  );
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

            // Tech-themed decoration
            SizedBox(height: 30.sp),
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.security,
                  size: 120.sp,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Create New Password",
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
                "Your new password must be different from your previous password",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 30.sp),

            // Password field
            TextFormField(
              key: Key('forgotPassword_newPassword_textfield'),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: Icon(Icons.lock_outline,
                    color: theme.colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide:
                      BorderSide(color: theme.colorScheme.secondary, width: 2),
                ),
              ),
            ),

            SizedBox(height: 16.sp),
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
            SizedBox(height: 40.sp),
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: 120.sp,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        );

      default:
        return SizedBox();
    }
  }

  Widget buildActionButtons(BuildContext context, ForgotPasswordState state) {
    final theme = Theme.of(context);
    final isLoading = state is ForgotPasswordLoading;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            flex: 2,
            child: ElevatedButton(
              key: Key('forgotPassword_back_button'),
              onPressed: isLoading ? null : _handleCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
                foregroundColor: theme.textTheme.bodyLarge?.color,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (_currentStep > 0) SizedBox(width: 12.sp),
        Expanded(
          flex: _currentStep > 0 ? 3 : 1,
          child: ElevatedButton(
            key: Key('forgotPassword_continue_button'),
            onPressed: isLoading ? null : _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: EdgeInsets.symmetric(vertical: 16.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.sp),
              ),
            ),
            child: Text(
              _currentStep == 2
                  ? (isLoading ? "Resetting..." : "Reset Password")
                  : (isLoading ? "Processing..." : "Continue"),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    if (_currentStep == 0) {
      email = emailController.text.trim();
      context.read<ForgetPasswordCubit>().sendEmail(email);
    } else if (_currentStep == 1) {
      final otp = otpController.text.trim();
      context.read<ForgetPasswordCubit>().verifyOtp(email, forgotToken, otp);
    } else if (_currentStep == 2) {
      final newPassword = passwordController.text.trim();
      context
          .read<ForgetPasswordCubit>()
          .resetPassword(email, newPassword, resetToken);
    }
  }

  void _handleCancel() {
    if (_currentStep == 0) {
      Navigator.pop(context); // Exit the screen
    } else {
      setState(() => _currentStep -= 1); // Go back one step
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
