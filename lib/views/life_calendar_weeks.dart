import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:flutter/material.dart';

class LifeCalendarWeeks extends StatefulWidget {
  const LifeCalendarWeeks({Key? key}) : super(key: key);

  @override
  _LifeCalendarWeeksState createState() => _LifeCalendarWeeksState();
}

class _LifeCalendarWeeksState extends State<LifeCalendarWeeks> {
  Widget _buildGrid() => GridView.count(
      padding: EdgeInsets.all(10),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      crossAxisCount: 52,
      children: _buildGridTileList(52 * currentUserSettings.lifespanYears));

  Widget _gridTile(int index) => Container(
        // TODO: get color from the user data if an entry is present for that week
        color: index < weeksAlive ? Colors.white70 : Colors.black,
        height: MediaQuery.of(context).size.height / 90,
      );

  List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (i) => Container(
            child: _gridTile(i),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGrid(),
      appBar: buildAppBar("Life Calendar (Weeks)"),
      bottomNavigationBar: Container(child: AdaptiveBannerAd()),
    );
  }
}
