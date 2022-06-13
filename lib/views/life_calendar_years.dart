import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:flutter/material.dart';

class LifeCalendarYears extends StatefulWidget {
  const LifeCalendarYears({Key? key}) : super(key: key);

  @override
  _LifeCalendarYearsState createState() => _LifeCalendarYearsState();
}

class _LifeCalendarYearsState extends State<LifeCalendarYears> {
  Widget _buildGrid() => GridView.count(
      padding: EdgeInsets.all(10),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      crossAxisCount: 10,
      children: _buildGridTileList(currentUserSettings.lifespanYears));

  Widget _gridTile(int index) => Container(
        // TODO: get color from the user data if an entry is present for that week
        color: index < daysAlive / daysInYear ? Colors.white70 : Colors.black,
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
      appBar: buildAppBar("Life Calendar (Years)"),
      bottomNavigationBar: Container(child: AdaptiveBannerAd()),
    );
  }
}
