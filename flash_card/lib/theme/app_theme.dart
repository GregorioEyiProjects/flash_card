import 'package:flash_card/app_colors.dart';
import 'package:flutter/material.dart';

//Light mode theme

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      ), //OutlinedBorder
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(AppColors.blueColor),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.textInBlack,
      fontSize: 18.0,
      fontFamily: 'Poppins',
    ),
    bodySmall: TextStyle(
      color: AppColors.blackTextColor,
      fontSize: 12.0,
      fontFamily: 'Poppins',
    ),
    headlineSmall: TextStyle(
      color: AppColors.textInBlack.withValues(alpha: 0.5),
      fontSize: 18.0,
      fontFamily: 'Poppins',
    ),
    labelLarge: TextStyle(
      color: AppColors.textInBlack, //Colors.amber,
      fontSize: 12.0,
      fontFamily: 'Poppins',
    ),
    titleLarge: TextStyle(
      color: AppColors.textInBlack,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    titleMedium: TextStyle(
      color: AppColors.textInBlack,
      fontSize: 14.0,
      fontFamily: 'Poppins',
    ),
    titleSmall: TextStyle(
      color: AppColors.textInBlack,
      fontSize: 10.0,

      fontFamily: 'Poppins',
    ),
  ),
  cardTheme: CardTheme(
    color: AppColors.backgroundColorWhite,
    shadowColor: AppColors.shadowColor,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  iconTheme: IconThemeData(color: Colors.black),
);

//Dark mode theme
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.amber, //AppColors.whiteTextColor,
      fontSize: 18.0,
      fontFamily: 'Poppins',
    ),
    bodySmall: TextStyle(
      color: AppColors.whiteTextColor,
      fontSize: 12.0,
      fontFamily: 'Poppins',
    ),
    headlineSmall: TextStyle(
      color: AppColors.whiteTextColor.withValues(alpha: 0.5),
      fontSize: 18.0,
      fontFamily: 'Poppins',
    ),
    labelLarge: TextStyle(
      color: AppColors.whiteTextColor, //Colors.amber,
      fontSize: 12.0,
      fontFamily: 'Poppins',
    ),
    labelMedium: TextStyle(
      color: AppColors.blackTextColor,
      fontSize: 12.0,
      fontFamily: 'Poppins',
    ),
    titleLarge: TextStyle(
      color: AppColors.whiteTextColor,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    titleMedium: TextStyle(
      color: AppColors.whiteTextColor,
      fontSize: 14.0,
      fontFamily: 'Poppins',
    ),
    titleSmall: TextStyle(
      color: AppColors.whiteTextColor,
      fontSize: 10.0,
      fontFamily: 'Poppins',
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.black54,
    shadowColor: AppColors.shadowColor,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  iconTheme: IconThemeData(color: Colors.amber),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.amber),
    ),
  ),
);
