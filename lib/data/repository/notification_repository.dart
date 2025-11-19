import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/core/extensions/time.dart';
import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/data/database/notification_prefs.dart';
import 'package:flutter_app_todo/data/services/notification_service.dart';
import 'package:flutter_app_todo/domain/entities/notification_settings_domain.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<NotificationRepository> notificationRepositoryProvider = Provider((ref) {
  return NotificationRepositoryImpl();
});

final Provider<NotificationStartupRepository> notificationStartupRepositoryProvider = Provider((ref) {
  return NotificationRepositoryImpl();
});

abstract class NotificationRepository {
  Future<NotificationSettingsDomain> loadSettings();
  Future<void> setEnabled({required bool enabled});
  Future<void> setEnabledMinute({required int minute});
  Future<void> setMorningEnabled({required bool enabled});
  Future<void> setEveningEnabled({required bool enabled});
  Future<void> setMorningTime({required int hour, required int minute});
  Future<void> setEveningTime({required int hour, required int minute});
  Future<void> scheduleTaskReminder({required TaskDomain task});
}

abstract class NotificationStartupRepository {
  Future<void> restoreMorningNotification();
  Future<void> restoreEveningNotification();
}

class NotificationRepositoryImpl implements NotificationRepository, NotificationStartupRepository {
  final _prefs = NotificationPrefs.instance;

  @override
  Future<NotificationSettingsDomain> loadSettings() async {
    if (kIsWeb) {
      return const NotificationSettingsDomain(
        enabled: false,
        enabledMinute: 5,
        morningEnabled: false,
        eveningEnabled: false,
        morningHour: 8,
        morningMinute: 0,
        eveningHour: 20,
        eveningMinute: 0,
      );
    }

    final hasPermission = await NotificationService.hasNotificationPermission();

    return NotificationSettingsDomain(
      enabled: await _prefs.getEnabled() && hasPermission,
      enabledMinute: await _prefs.getEnabledMinute(),
      morningEnabled: await _prefs.getMorningEnabled(),
      eveningEnabled: await _prefs.getEveningEnabled(),
      morningHour: await _prefs.getMorningHour(),
      morningMinute: await _prefs.getMorningMinute(),
      eveningHour: await _prefs.getEveningHour(),
      eveningMinute: await _prefs.getEveningMinute(),
    );
  }

  @override
  Future<void> setEnabled({required bool enabled}) async {
    if (kIsWeb) throw UnsupportedError('Notifications not supported on web');

    await _prefs.setEnabled(enabled);

    if (!enabled) {
      await NotificationService.cancel(2001);
      await NotificationService.cancel(2002);
      return;
    }

    final hasPermission = await NotificationService.hasNotificationPermission();

    if (!hasPermission) {
      final granted = await NotificationService.requestPermissions();

      if (!granted) {
        await _prefs.setEnabled(false);
        return;
      }
    }

    if (await _prefs.getMorningEnabled()) {
      await NotificationService.cancel(2001);
      await _scheduleMorningDaily();
    }

    if (await _prefs.getEveningEnabled()) {
      await NotificationService.cancel(2002);
      await _scheduleEveningDaily();
    }
  }

  @override
  Future<void> setEnabledMinute({required int minute}) async {
    await _prefs.setEnabledMinute(minute);
  }

  @override
  Future<void> setMorningEnabled({required bool enabled}) async {
    if (kIsWeb) throw UnsupportedError('Notifications not supported on web');

    await _prefs.setMorningEnabled(enabled);
    if (!enabled) {
      await NotificationService.cancel(2001);
    } else {
      await _scheduleMorningDaily();
    }
  }

  @override
  Future<void> setMorningTime({required int hour, required int minute}) async {
    await _prefs.setMorningTime(hour, minute);
    await NotificationService.cancel(2001);
    if (await _prefs.getMorningEnabled()) {
      await _scheduleMorningDaily();
    }
  }

  @override
  Future<void> setEveningEnabled({required bool enabled}) async {
    if (kIsWeb) throw UnsupportedError('Notifications not supported on web');

    await _prefs.setEveningEnabled(enabled);
    if (!enabled) {
      await NotificationService.cancel(2002);
    } else {
      await _scheduleEveningDaily();
    }
  }

  @override
  Future<void> setEveningTime({required int hour, required int minute}) async {
    await _prefs.setEveningTime(hour, minute);
    await NotificationService.cancel(2002);
    if (await _prefs.getEveningEnabled()) {
      await _scheduleEveningDaily();
    }
  }

  @override
  Future<void> scheduleTaskReminder({required TaskDomain task}) async {
    try {
      if (!task.hasDateTime) {
        log('Task has no date/time: ${task.id}');
        return;
      }

      final dateTime = combineDateAndTime(task.date!, task.time!);
      if (dateTime == null) return;

      final reminderMinutes = await _prefs.getEnabledMinute();

      final advanceTime = dateTime.subtract(Duration(minutes: reminderMinutes));
      final advanceId = Object.hash(task.id, Constants.advanceId);

      if (advanceTime.isAfter(DateTime.now()) && reminderMinutes != 0) {
        await NotificationService.showScheduleNotificationDateTime(
          id: advanceId,
          title: 'Coming soon: ${task.title}',
          body: task.description.isNotEmpty ? task.description : 'The task will start in $reminderMinutes min',
          dateTime: advanceTime,
          payload: 'task_${task.id}',
        );
      }

      final exactId = Object.hash(task.id, Constants.exactId);
      if (dateTime.isAfter(DateTime.now())) {
        await NotificationService.showScheduleNotificationDateTime(
          id: exactId,
          title: 'It is time! ${task.title}',
          body: task.description.isNotEmpty ? task.description : 'The task begins right now!',
          dateTime: dateTime,
          payload: 'task_${task.id}',
        );
      }
    } catch (e, s) {
      log('Error scheduling task reminder', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> restoreMorningNotification() async {
    if (!await _prefs.getMorningEnabled()) return;
    await _scheduleMorningDaily();
  }

  @override
  Future<void> restoreEveningNotification() async {
    if (!await _prefs.getEveningEnabled()) return;
    await _scheduleEveningDaily();
  }

  Future<void> _scheduleMorningDaily() async {
    final hour = await _prefs.getMorningHour();
    final minute = await _prefs.getMorningMinute();
    await NotificationService.showScheduleNotification(
      id: 2001,
      title: "Today’s tasks",
      body: "Check today's tasks",
      time: Time(hour, minute),
      payload: null,
    );
  }

  Future<void> _scheduleEveningDaily() async {
    final hour = await _prefs.getEveningHour();
    final minute = await _prefs.getEveningMinute();
    await NotificationService.showScheduleNotification(
      id: 2002,
      title: "Daily summary",
      body: "What did you manage to accomplish today?",
      time: Time(hour, minute),
      payload: null,
    );
  }
}
