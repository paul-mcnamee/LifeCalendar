import 'package:flutter/material.dart';
import 'package:life_calendar/components/globals.dart';

AppBar buildAppBar(String? title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(title ?? appTitle),
  );
}
