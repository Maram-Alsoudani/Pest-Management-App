import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/font_manager.dart';

class MyTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: ColorManager.backgroundColor,
    appBarTheme: const AppBarTheme(
      foregroundColor: ColorManager.whiteColor,
      backgroundColor: ColorManager.backgroundColor,
    ),
    iconTheme: const IconThemeData(
      color: ColorManager.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize: FontSize.s20,
        fontWeight: FontWeight.w700,
        color: ColorManager.whiteColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: FontSize.s15,
        color: ColorManager.whiteColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: FontSize.s15,
        color: ColorManager.blackColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: FontSize.s21,
        fontWeight: FontWeight.w700,
        color: ColorManager.blackColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: FontSize.s14,
        color: ColorManager.blackColor,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeightManager.bold,
        fontSize: FontSize.s16,
        color: ColorManager.blackColor,
      ),
      headlineMedium: TextStyle(
        fontSize: FontSize.s13,
        color: ColorManager.greyShade5,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorManager.blueColor,
      selectionColor: ColorManager.blueColor.withAlpha((0.5 * 255).toInt()),
      selectionHandleColor: ColorManager.blueColor,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}
