
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_calendar/views/daily_entry.dart';
import 'package:life_calendar/views/entries_7d_view.dart';
import 'package:life_calendar/views/home.dart';
import 'package:life_calendar/views/life_calendar_months.dart';
import 'package:life_calendar/views/life_calendar_weeks.dart';
import 'package:life_calendar/views/life_calendar_years.dart';
import 'package:life_calendar/views/settings.dart';
import 'package:life_calendar/components/entries_7d.dart';

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
          // margin: const EdgeInsets.only(bottom: 0),
        ),
        drawerTile(context, 'Home', Home()),
        drawerTile(context, 'Daily Entry', DailyEntry(inputDate: null,)),
        drawerTile(context, 'Past Entries (7d)', Entries7dView()),
        // drawerTile(context, 'Current Week', CurrentWeek()),
        // drawerTile(context, 'Current Month', CurrentMonth()),
        // drawerTile(context, 'Current Year', CurrentYear()),
        // drawerTile(context, 'Life Calendar (Weeks)', LifeCalendarWeeks()),
        drawerTile(context, 'Life Calendar (Months)', LifeCalendarMonths()),
        drawerTile(context, 'Life Calendar (Years)', LifeCalendarYears()),
        // drawerTile(context, 'Endless', Endless()),
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