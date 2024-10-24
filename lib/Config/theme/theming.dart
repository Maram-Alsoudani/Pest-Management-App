import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesticides/Core/utils/colors.dart';

class MyTheme {
  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: ColorManager.backgroundColor,
    appBarTheme: AppBarTheme(
      foregroundColor: ColorManager.whiteColor,
      backgroundColor: ColorManager.backgroundColor,
    ),
    iconTheme: IconThemeData(
      color: ColorManager.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA11B1B),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      titleSmall: GoogleFonts.poppins(
        fontSize: 15.sp,
        color: ColorManager.whiteColor,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorManager.blueColor,
      selectionColor: ColorManager.blueColor.withOpacity(0.5),
      selectionHandleColor: ColorManager.blueColor,
    ),
  );
}
