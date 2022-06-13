import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/calendar_component.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarComponent(),
      appBar: buildAppBar("Calendar"),
      bottomNavigationBar: Container(child: AdaptiveBannerAd()),
    );
  }
}
