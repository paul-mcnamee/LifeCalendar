import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:flutter/material.dart';

class LifeCalendarMonths extends StatefulWidget {
  const LifeCalendarMonths({Key? key}) : super(key: key);

  @override
  _LifeCalendarMonthsState createState() => _LifeCalendarMonthsState();
}

class _LifeCalendarMonthsState extends State<LifeCalendarMonths> {
  Widget _buildGrid() => GridView.count(
      padding: EdgeInsets.all(10),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      crossAxisCount: 26,
      children: _buildGridTileList(13 * currentUserSettings.lifespanYears));


  var days = daysAlive();
  Widget _gridTile(int index) => Container(
        // TODO: get color from the user data if an entry is present for that week
        color: index % 13 == 0
            ? null
            : index < days / 30
                ? Colors.white70
                : Colors.black,
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
      appBar: buildAppBar("Life Calendar (Months)"),
      bottomNavigationBar: Container(child: AdaptiveBannerAd()),
    );
  }
}
