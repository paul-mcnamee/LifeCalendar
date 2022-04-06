import 'package:flutter/material.dart';

class GreetingComponent extends StatefulWidget {
  @override
  State<GreetingComponent> createState() => _GreetingComponentState();
}

class _GreetingComponentState extends State<GreetingComponent> {
  String text = "";

  int now = DateTime.now().hour;

  String timeCall() {
    if (now <= 11) {
      text = "Good Morning  ☀️";
    }
    if (now > 11) {
      text = "Good Afternoon  🌞";
    }
    if (now >= 17) {
      text = "Good Evening  🌙";
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
