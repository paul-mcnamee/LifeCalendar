import 'package:life_calendar/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/components/quote.dart';
import 'package:life_calendar/views/settings.dart';

import '../components/calendar_component.dart';
import '../components/greeting_component.dart';
import 'daily_entry.dart';
import 'entries_7d_view.dart';
import 'life_calendar_months.dart';
import 'life_calendar_years.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeContainer(),
      appBar: buildAppBar("Home"),
    );
  }
}

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 1,
        child: Center(
            child: Container(
          child: GreetingComponent(),
          padding: EdgeInsets.only(top: 4),
          height: 60,
        )),
      ),
      Flexible(
        flex: 2,
        child: Center(
            child: Container(
          child: Quote(),
          padding: EdgeInsets.all(4),
        )),
      ),
      Flexible(
        flex: 16,
        child: GridView.count(
            padding: EdgeInsets.all(10),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: constructNavTiles(context)),
      ),
    ]);
  }

  List<Widget> constructNavTiles(BuildContext context) {
    List<Widget> navTiles = <Widget>[];

    navTiles.add(navTile(context, 'Calendar', CalendarComponent(),
        navTileIcon(Icons.calendar_today_outlined, "Calendar")));
    navTiles.add(navTile(
        context,
        'Daily Entry',
        DailyEntry(
          inputPost: null,
        ),
        navTileIcon(Icons.add, "daily entry")));
    navTiles.add(navTile(context, 'Past Entries\n(7 days)', Entries7dView(),
        navTileIcon(Icons.view_list, "past entries 7 days")));
    navTiles.add(navTile(
        context,
        'Life Calendar\n(Months)',
        LifeCalendarMonths(),
        navTileIcon(
            Icons.calendar_view_month, "life calendar view in months")));
    navTiles.add(navTile(context, 'Life Calendar\n(Years)', LifeCalendarYears(),
        navTileIcon(Icons.calendar_view_week, "life calendar view in years")));
    navTiles.add(navTile(context, 'Settings', Settings(),
        navTileIcon(Icons.settings, "settings")));

    return navTiles;
  }

  Container navTileIcon(IconData? icon, String labelText) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Icon(
          icon,
          color: Colors.white,
          size: 48,
          semanticLabel: labelText,
        ));
  }

  Container navTile(
      BuildContext context, String tileText, Widget page, Widget icon) {
    return Container(
        child: InkWell(
      splashColor: Colors.tealAccent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.teal.shade700,
        ),
        padding: EdgeInsets.all(6),
        child: Container(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.teal.shade800,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                Center(
                    child: Text(
                  tileText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
