import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF7B1FF2);
  static const Color secondaryPurple = Color(0xFF9333EA);
  static const Color orangeAccent = Color(0xFFFF7A2F);
  static const Color background = Color(0xFFF4F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textLight = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: orangeAccent,
      background: background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: orangeAccent,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}