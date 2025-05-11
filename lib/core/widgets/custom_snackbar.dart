import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    
    // Define colors and icons based on type
    Color backgroundColor;
    Icon icon;
    
    switch (type) {
      case SnackBarType.success:
        backgroundColor = theme.colorScheme.primary.withOpacity(0.9);
        icon = Icon(Icons.check_circle_outline, color: Colors.white);
        break;
      case SnackBarType.error:
        backgroundColor = theme.colorScheme.error.withOpacity(0.9);
        icon = Icon(Icons.error_outline, color: Colors.white);
        break;
      case SnackBarType.info:
        backgroundColor = theme.colorScheme.secondary.withOpacity(0.9);
        icon = Icon(Icons.info_outline, color: Colors.white);
        break;
    }
    
    // Create and show SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 60.sp, left: 20.sp, right: 20.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.sp),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        content: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
