import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final String? keyName;
  final String text;
  //bool? isSearching=false;
  //List<dynamic>? allItems;
  //List<dynamic>? searchedItems;
  final Function onPress;
  final Function onTextChange;
  final TextEditingController controller;

  final Color? backgroundColor;

  CustomSearchBar(
      {this.keyName,
      required this.text,
      //this.isSearching,
      //this.allItems,
      //this.searchedItems,
      required this.onPress,
      required this.onTextChange,
      required this.controller,
      this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
            onPress();
          } ,
      child: Container(
          height: 50.h,
         width: 900.w,
        //padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          key: Key(keyName ?? 'Search bar'),
          cursorColor: Colors.red[400],
          controller: controller,
          enabled: false,
          onTap: () {
            onPress();
          },
          onChanged: (searched) {
            onTextChange(searched);
          },
          decoration: InputDecoration(
            hintText: text,
            prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.black87),
            filled: true,
            fillColor: backgroundColor ?? Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}
