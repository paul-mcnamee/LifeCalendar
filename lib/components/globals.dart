import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
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

int monthsAlive() {
  if (currentUserSettings.birthday != birthday)
    birthday = currentUserSettings.birthday;
  return Jiffy(currentDate).diff(birthday, Units.MONTH).toInt();
}

int daysAlive() {
  if (currentUserSettings.birthday != birthday)
    birthday = currentUserSettings.birthday;
  return Jiffy(currentDate).diff(birthday, Units.DAY).toInt();
}

int weeksAlive() {
  if (currentUserSettings.birthday != birthday)
    birthday = currentUserSettings.birthday;
  return Jiffy(currentDate).diff(birthday, Units.WEEK).toInt();
}

int yearsAlive() {
  if (currentUserSettings.birthday != birthday)
    birthday = currentUserSettings.birthday;
  return Jiffy(currentDate).diff(birthday, Units.YEAR).toInt();
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
