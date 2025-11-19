import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_todo/core/extensions/time.dart';
import 'package:flutter_app_todo/domain/usecases/notification/restore_daily_notifications_usecase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> init({bool initScheduled = false}) async {
    if (kIsWeb) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null) {
          onNotifications.add(payload);
        }
      },
    );

    if (initScheduled) {
      try {
        tz.initializeTimeZones();
        final locationName = await _getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(locationName));
      } catch (e) {
        log('Error initializing timezone: $e');
      }
    }

    final pending = await _notifications.pendingNotificationRequests();
    log('Scheduled: ${pending.length}');
    for (final n in pending) {
      log('id=${n.id}, title=${n.title}');
    }
  }

  static Future<String> _getLocalTimezone() async {
    String currentTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;
    if (currentTimeZone.contains('Europe/Kiev')) {
      currentTimeZone = 'Europe/Kyiv';
    }
    return currentTimeZone;
  }

  static Future<bool> requestPermissions() async {
    bool granted = false;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      granted = result ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final notifGranted =
          await _notifications
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;

      final exactGranted =
          await _notifications
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestExactAlarmsPermission() ??
          false;

      granted = notifGranted || exactGranted;
    }

    return granted;
  }

  static Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channel Name',
        channelDescription: 'channel Description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    required String? title,
    required String? body,
    required String? payload,
  }) async {
    await _notifications.show(id, title, body, await _notificationDetails(), payload: payload);
  }

  static Future<void> showScheduleNotification({
    int id = 1,
    required String? title,
    required String? body,
    required String? payload,
    required Time time,
  }) async {
    final tzScheduledDate = _scheduledDaily(time);

    final hasExactAlarmPermission = await Permission.scheduleExactAlarm.isGranted;
    final scheduleMode = hasExactAlarmPermission
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    log('Scheduled id=$id, title=$title');

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showScheduleNotificationDateTime({
    int id = 1,
    required String? title,
    required String? body,
    required String? payload,
    required DateTime dateTime,
  }) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    final hasExactAlarmPermission = await Permission.scheduleExactAlarm.isGranted;

    final scheduleMode = hasExactAlarmPermission
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    log('Scheduled id=$id, title=$title, date=$scheduledDate');

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static tz.TZDateTime _scheduledDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    log('All notifications cancelled');
  }

  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> restoreScheduledNotifications() async {
    try {
      final container = ProviderContainer();
      try {
        await container.read(restoreDailyNotificationsUseCaseProvider).execute();
      } finally {
        container.dispose();
      }
    } catch (e, st) {
      log('Error restoring notifications: $e\n$st');
    }
  }
}
