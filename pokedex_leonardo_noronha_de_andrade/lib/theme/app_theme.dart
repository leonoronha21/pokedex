import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFDE1B36);
  static const Color backgroundColor = Color(0xFFF6F6F6);
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color accentColor = Color(0xFFDE1B36);

  static ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: accentColor,
        ),
        cardColor: cardColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
