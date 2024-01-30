import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  var mNotificationManager = FlutterLocalNotificationsPlugin();

  initialNotificationManager() {
    var initialSetting = const InitializationSettings(
      android: AndroidInitializationSettings("chat"),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    mNotificationManager.initialize(initialSetting);

    if (Platform.isAndroid) {
      mNotificationManager
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
  }

  /// Send Local Notification
  sendNotification({required int id, required String title, String? body}) {
    var notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails("Test", "Test Local Channel"),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    mNotificationManager.show(id, title, body, notificationDetails);
  }

  /// Send Periodic Notification
  sendPeriodicNotification(
      {required int id, required String title, String? body}) {
    var notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails("Test", "Test Periodic Channel"),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    mNotificationManager.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }

  /// Send Scheduled Notification
  sendScheduledNotification(
      {required int id, required String title, String? body}) async {
    var notificationDetails = const NotificationDetails(
      android:
          AndroidNotificationDetails("Test", "Test Scheduled Notification"),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    tz.setLocalLocation(
      tz.getLocation(
        await FlutterTimezone.getLocalTimezone(),
      ),
    );

    mNotificationManager.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
