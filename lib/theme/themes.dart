import 'package:flutter/material.dart';

class DefaultTheme {
  ThemeData get theme => ThemeData(
      primaryColor: Colors.teal.shade600,
      primaryColorDark: Colors.teal.shade800,
      primaryColorLight: Colors.teal.shade300,
      focusColor: Colors.teal.shade300,
      backgroundColor: Colors.black45,
      colorScheme: ColorScheme.dark(
        primary: Colors.teal.shade600,
        // primaryContainer: Colors.teal.shade200,
        secondary: Colors.teal.shade800,
        // secondaryContainer: Colors.teal.shade900,
      ));
}
