import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customDividerWithText(
    {double? thickness,
    Color? color,
    double? width,
    EdgeInsets? margin,
    required Text child}) {
  return Container(
    margin: margin ?? EdgeInsets.symmetric(vertical: 20.sp),
    width: width ?? 0.85.sw,
    child: Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? Colors.grey[300],
            thickness: thickness ?? 1.sp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: child,
        ),
        Expanded(
          child: Divider(
            color: color ?? Colors.grey[300],
            thickness: thickness ?? 1,
          ),
        ),
      ],
    ),
  );
}
