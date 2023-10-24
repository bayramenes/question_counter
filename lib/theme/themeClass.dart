import 'package:flutter/material.dart';

class ThemeClass {
  // dark theme for the app
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(primary: const Color(0xFF4ECCA3)),
    primaryColor: const Color(0xFF4ECCA3),
    primaryIconTheme: const IconThemeData(color: Color(0xEEEEEEEE)),
    scaffoldBackgroundColor: const Color(0xFF2B2B2B),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF222222),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xaa393E46),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        fontSize: 20,
        color: Color(0xFFE4E4E4),
      ),
      bodyText2: TextStyle(
        fontSize: 20,
        color: Color(0xDDF5EDED),
      ),
    ),
    canvasColor: const Color(0xFF393E46),
  );

  // date picker theme

// date picker theme that work for android
  static ThemeData datePickerTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4ECCA3),
    ),
  );

  static InputDecoration buildTextField(String hintText) {
    return InputDecoration(
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade800),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade800),
      ),
      // style of the place holder
      hintStyle: const TextStyle(color: Color(0xDDF5EDED)),
      // the border that shows up when the modal bottom sheet is opened even if the user didn't press on it
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding:
          const EdgeInsets.only(top: 3, bottom: 3, left: 17, right: 8),
      hintText: hintText,
      // border when the text field is being used
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4ECCA3)),
      ),
    );
  }

// theme data for chart bar contianer

}
