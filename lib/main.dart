// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:support/features/customer_support/screens/complaints_list_screen.dart';
// import 'package:support/features/customer_support/screens/statistics_screen.dart';
// import 'package:support/core/theming/app_theme.dart';
// import 'package:support/features/auth/login/ui/screens/login_screen.dart';
// import 'package:support/core/screens/main_screen.dart';

// void main() {
//   runApp(const SupportApp());
// }

// class SupportApp extends StatelessWidget {
//   const SupportApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(412, 924),
//       minTextAdapt: true,
//       builder: (context, child) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Customer Service',
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         themeMode: ThemeMode.system,
//         home: LoginScreen(),
//         routes: {
//           '/login': (context) => LoginScreen(),
//           '/main': (context) => const MainScreen(),
//         },
//       ),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final _screens = [
//     const ComplaintsListScreen(),
//     const StatisticsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         onTap: (i) => setState(() => _selectedIndex = i),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment),
//             label: 'Complaints',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: 'Statistics',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/core/helpers/auth_helpers/constants.dart';
import 'package:support/core/routing/app_router.dart';
import 'package:support/core/routing/routes.dart';
import 'package:support/core/theming/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();
  await checkIfConfirmedUser();

  runApp(MainApp(
    appRouter: AppRouter(),
  ));
}

class MainApp extends StatelessWidget {
  final AppRouter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedInUser ? Routes.mainScreen : Routes.loginScreen,

          theme: AppTheme.lightTheme, // Light theme
          darkTheme: AppTheme.darkTheme, // Dark theme
          themeMode: ThemeMode.system, // Auto-switch based on system settings
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}

Future<void> checkIfLoggedInUser() async {
  try {
    AuthService authService = getIt<AuthService>();
    String? userToken = await authService.getAccessToken();
    if (userToken == null || userToken.isEmpty) {
      isLoggedInUser = false;
    } else {
      bool refreshResult = await authService.refreshToken();
      isLoggedInUser = refreshResult;
    }
  } catch (e) {
    print("Error in checkIfLoggedInUser: $e");
    isLoggedInUser = false;
  }
}

// check if confirmed user
Future<void> checkIfConfirmedUser() async {
  try {
    AuthService authService = getIt<AuthService>();
    String? token = await authService.getAccessToken();
    if (token == null || token.isEmpty) {
      isConfirmedUser = false;
    } else {
      isConfirmedUser = await authService.getConfirmationStatus();
    }
  } catch (e) {
    print("Error in checkIfConfirmedUser: $e");
    isConfirmedUser = false;
  }

  if (!isConfirmedUser) {
    // If the user is not confirmed, clear the user info
    AuthService authService = getIt<AuthService>();
    await authService.clearUserInfo();
    isLoggedInUser = false;
  }
}

