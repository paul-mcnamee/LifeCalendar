import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:life_calendar/views/settings.dart';

const String appTitle = "Life Calendar";

final currentDate = DateTime.now().toLocal();
final currentDateMS = currentDate.millisecondsSinceEpoch;
DateTime convertedCurrentDate =
    new DateTime(currentDate.year, currentDate.month, currentDate.day);

var birthday = new DateTime(1989, 12, 12);

var daysInYear = 365.242196;

int lifespanYears = 78;

int lifespanDays() {
  if (currentUserSettings.lifespanYears != lifespanYears)
    lifespanYears = currentUserSettings.lifespanYears;
  return (daysInYear * lifespanYears).ceil();
}

DateTime death() {
  if (currentUserSettings.birthday != birthday)
      birthday = currentUserSettings.birthday;
  return birthday.add(Duration(days: lifespanDays()));
}

Duration diff() {
  if (currentUserSettings.birthday != birthday)
    birthday = currentUserSettings.birthday;
  return currentDate.difference(birthday);
}

int daysAlive() {
  return diff().inDays.abs();
}

int weeksAlive() {
  return (daysAlive() / 7).ceil();
}

int yearsAlive() {
  return (daysAlive() / daysInYear).ceil();
}

int daysLeft() {
  return death().difference(currentDate).inDays.abs();
}
int  weeksLeft() {
  return (daysLeft() / 7).floor();
}

int yearsLeft() {
  return (daysLeft() / daysInYear).floor();
}

DateFormat dateFormatDate = DateFormat("yyyy-MM-dd");
NumberFormat numberFormatNoTrailing = NumberFormat("#", "en-us");

var inAppInfoMessagesPaused = false;

var dailyNotificationsPaused = false;
var dailyNotificationTime = DateTime(2022, 4, 20, 21, 30);

var hideLifeCalendarTiles = false;

String dailyEntryTemplate = "What made you happy today?\n\n"
    "What did you do well today?\n\n"
    "What did you think about a lot today?\n\n"
    "What do you think you could have done better?\n\n";

UserSettings defaultUserSettings = new UserSettings(
  lifespanYears: lifespanYears,
  inAppInfoMessagesPaused: inAppInfoMessagesPaused,
  birthday: birthday,
  dailyEntryTemplate: dailyEntryTemplate,
  dailyNotificationTime: dailyNotificationTime,
  dailyNotificationsPaused: dailyNotificationsPaused,
  hideLifeCalendarTiles: hideLifeCalendarTiles,
  userId: '',
);

UserSettings currentUserSettings = new UserSettings(
  lifespanYears: lifespanYears,
  inAppInfoMessagesPaused: inAppInfoMessagesPaused,
  birthday: birthday,
  dailyNotificationTime: dailyNotificationTime,
  dailyNotificationsPaused: dailyNotificationsPaused,
  dailyEntryTemplate: dailyEntryTemplate,
  hideLifeCalendarTiles: hideLifeCalendarTiles,
  userId: '',
);
