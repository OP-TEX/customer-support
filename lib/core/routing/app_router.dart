import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/routing/routes.dart';
import 'package:support/core/screens/main_screen.dart';
import 'package:support/features/auth/confirmation/logic/cubit/confirmation_cubit.dart';
import 'package:support/features/auth/confirmation/ui/screens/confirmation_screen.dart';
import 'package:support/features/auth/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:support/features/auth/forgetpassword/ui/screens/forgetpassword_screen.dart';
import 'package:support/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:support/features/auth/login/ui/screens/login_screen.dart';
import 'package:support/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:support/features/auth/signup/ui/screens/signup_screen.dart';
import 'package:support/features/customer_support/screens/complaints_list_screen.dart';
import 'package:support/features/customer_support/screens/statistics_screen.dart';
import 'package:support/features/customer_support/screens/support_chat_screen.dart';

String lastComplaintId = "";
String lastDevice = "";

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: SignupScreen(),
          ),
        );

      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgetPasswordCubit>(),
            child: ForgotPasswordSteps(),
          ),
        );
      // All main tabs under a single container with a shared cubit
      case Routes.confirmationScreen:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EmailConfirmationCubit>()
                ..resendConfirmationEmail(arguments),
              child: ConfirmationScreen(email: arguments),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                    "Invalid arguments for EmailConfirmationScreen. Email is required."),
              ),
            ),
          );
        }
      case Routes.mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (_) => StatisticsScreen());
      case Routes.complaintsListScreen:
        return MaterialPageRoute(builder: (_) => ComplaintsListScreen());
      case Routes.supportChatScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SupportChatScreen(
            complaint: args?['complaint'],
          ),
        );
      default:
        return null;
    }
  }
}
