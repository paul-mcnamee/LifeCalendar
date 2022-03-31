import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/components/quote.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Quote()),
      appBar: buildAppBar("Home"),
      drawer: buildDrawer(context),
    );
  }




}