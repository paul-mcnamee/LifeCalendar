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
var lifespanDays = (daysInYear * lifespanYears).ceil();

var death = birthday.add(Duration(days: lifespanDays));

var diff = currentDate.difference(birthday);

var daysAlive = diff.inDays.abs();
var weeksAlive = (daysAlive / 7).ceil();
var yearsAlive = (daysAlive / daysInYear).ceil();

var daysLeft = death.difference(currentDate).inDays.abs();
var weeksLeft = (daysLeft / 7).floor();
var yearsLeft = (daysLeft / daysInYear).floor();

DateFormat dateFormatDate = DateFormat("yyyy-MM-dd");
NumberFormat numberFormatNoTrailing = NumberFormat("#", "en-us");

var inAppInfoMessagesPaused = false;

var dailyNotificationsPaused = false;
var dailyNotificationTime = DateTime(2022, 4, 20, 21, 30);

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
  userId: '',
);

UserSettings currentUserSettings = new UserSettings(
  lifespanYears: lifespanYears,
  inAppInfoMessagesPaused: inAppInfoMessagesPaused,
  birthday: birthday,
  dailyNotificationTime: dailyNotificationTime,
  dailyNotificationsPaused: dailyNotificationsPaused,
  dailyEntryTemplate: dailyEntryTemplate,
  userId: '',
);
