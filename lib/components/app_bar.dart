import 'package:flutter/material.dart';
import 'package:life_calendar/components/globals.dart';

AppBar buildAppBar(String? title) {
  return AppBar(
    title: Text(title ?? appTitle),
  );
}