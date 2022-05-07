import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    fontFamily: 'Source_Sans',
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        color: Colors.black54,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.white70,
      foregroundColor: Colors.black87,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.black87,
      style: ListTileStyle.list,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green[600],
    ),
  );
}
