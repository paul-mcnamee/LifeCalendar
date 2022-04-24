import 'package:flutter/material.dart';
import 'package:life_calendar/components/globals.dart';

class GreetingComponent extends StatefulWidget {
  @override
  State<GreetingComponent> createState() => _GreetingComponentState();
}

class _GreetingComponentState extends State<GreetingComponent> {
  String text = "";

  DateTime now = DateTime.now();

  DateTime nowDay = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime userBirthday = new DateTime(DateTime.now().year,
      currentUserSettings.birthday.month, currentUserSettings.birthday.day);

  String timeCall() {
    if (userBirthday.difference(nowDay).inDays.abs() == 0) {
      return "Happy Birthday  🎂";
    }
    if (now.hour <= 11) {
      return "Good Morning  ☀️";
    }
    if (now.hour > 11) {
      return "Good Afternoon  🌞";
    }
    if (now.hour >= 17) {
      return "Good Evening  🌙";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      timeCall(),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 24,
      ),
    ));
  }
}
