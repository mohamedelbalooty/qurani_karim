import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: mainColor,
    primarySwatch: Colors.purple,
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: Colors.grey.shade50,
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      titleTextStyle: TextStyle(
          color: whiteColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal'),
      centerTitle: true,
      iconTheme: const IconThemeData(color: whiteColor),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: whiteColor,
        fontSize: 38.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: whiteColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: mainDarkColor,
    primarySwatch: Colors.purple,
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: secondDarkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: mainDarkColor,
      titleTextStyle: TextStyle(
          color: mainDarkColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal'),
      centerTitle: true,
      iconTheme: const IconThemeData(color: whiteColor),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: mainDarkColor,
        fontSize: 38.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: whiteColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
