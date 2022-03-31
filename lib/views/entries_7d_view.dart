import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/app_drawer.dart';
import 'package:life_calendar/components/entries_7d.dart';
import 'package:flutter/material.dart';

class Entries7dView extends StatefulWidget {
  const Entries7dView({Key? key}) : super(key: key);

  @override
  _Entries7dState createState() => _Entries7dState();
}

class _Entries7dState extends State<Entries7dView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Entries7d(),
      appBar: buildAppBar("Entries (7d)"),
      drawer: buildDrawer(context),
    );
  }
}