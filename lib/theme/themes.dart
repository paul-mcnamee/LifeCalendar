import 'package:flutter/material.dart';

class DefaultTheme {
  ThemeData get theme => ThemeData(
      primaryColor: Colors.teal.shade700,
      backgroundColor: Colors.black45,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xff03dac6),
        primaryContainer: const Color(0xff03dac6),
        secondary: const Color(0xffbb86fc),
        secondaryContainer: const Color(0xff3700B3),
      ));
}
