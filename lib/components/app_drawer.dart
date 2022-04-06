import 'package:flutter/material.dart';
import 'package:life_calendar/views/daily_entry.dart';
import 'package:life_calendar/views/entries_7d_view.dart';
import 'package:life_calendar/views/home.dart';
import 'package:life_calendar/views/life_calendar_months.dart';
import 'package:life_calendar/views/life_calendar_years.dart';
import 'package:life_calendar/views/settings.dart';

import 'calendar_component.dart';

@deprecated
Drawer buildDrawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text(
            'Life Calendar',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
          padding: const EdgeInsets.fromLTRB(4.0, 50.0, 4.0, 4.0),
        ),
        drawerTile(context, 'Home', Home()),
        drawerTile(context, 'Calendar', CalendarComponent()),
        drawerTile(
            context,
            'Daily Entry',
            DailyEntry(
              inputPost: null,
            )),
        drawerTile(context, 'Past Entries (7d)', Entries7dView()),
        drawerTile(context, 'Life Calendar (Months)', LifeCalendarMonths()),
        drawerTile(context, 'Life Calendar (Years)', LifeCalendarYears()),
        drawerTile(context, 'Settings', Settings()),
      ],
    ),
  );
}

ListTile drawerTile(BuildContext context, String tileTitle, Widget widget) {
  return ListTile(
    title: Text(tileTitle),
    onTap: () {
      // Update the state of the app
      // ...
      // Then close the drawer
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
    },
  );
}
