import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are set
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> setReminderNotification(
      int id, String title, String body) async {
    if (currentUserSettings.dailyNotificationsPaused)
      return cancelAllNotifications();

    await flutterLocalNotificationsPlugin.cancelAll();

    // TODO: need to check if this is actually working still, seemed like it was??
    var timeToComeFromSettings = currentUserSettings.dailyNotificationTime;

    // TODO: delete after testing...
    timeToComeFromSettings = DateTime.now().add(Duration(seconds: 5));

    //schedule the notification to show based on the user setting.
    var localTimezone = tz.local;
    var notificationTime =
        tz.TZDateTime.from(timeToComeFromSettings, localTimezone);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      notificationTime,
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "Life Calendar",
            importance: Importance.high,
            priority: Priority.high),

        // iOS details
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
      matchDateTimeComponents: DateTimeComponents.time, // daily notifications
    );
  }
}
