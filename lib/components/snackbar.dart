import 'package:flutter/material.dart';
import 'package:life_calendar/components/globals.dart';

class ShowSnackBar {
  ShowSnackBar._();
  static normal(BuildContext context, String message) {
    if (inAppInfoMessagesPaused)
      return;

    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}