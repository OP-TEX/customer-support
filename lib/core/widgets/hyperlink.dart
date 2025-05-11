import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final Color color;
  final String url;
  final double size;

  const Hyperlink({
    super.key,
    required this.text,
    required this.color,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: size.sp,
        ),
      ),
    );
  }
}
