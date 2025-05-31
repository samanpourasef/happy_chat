import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 32),
      bodyMedium: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),
      titleMedium: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
      labelMedium: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16),
      labelSmall: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 12),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
    ),
  );
}
