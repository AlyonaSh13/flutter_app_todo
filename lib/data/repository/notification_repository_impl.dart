import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/core/extensions/time.dart';
import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/data/database/notification_prefs.dart';
import 'package:flutter_app_todo/data/services/notification_service.dart';
import 'package:flutter_app_todo/domain/entities/notification_settings_domain.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<NotificationRepository> notificationRepositoryProvider = Provider((ref) {
  final notificationPrefs = ref.watch(notificationPrefsProvider);
  return NotificationRepositoryImpl(notificationPrefs);
});

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._notificationPrefs);

  final NotificationPrefs _notificationPrefs;

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
      enabled: await _notificationPrefs.getEnabled() && hasPermission,
      enabledMinute: await _notificationPrefs.getEnabledMinute(),
      morningEnabled: await _notificationPrefs.getMorningEnabled(),
      eveningEnabled: await _notificationPrefs.getEveningEnabled(),
      morningHour: await _notificationPrefs.getMorningHour(),
      morningMinute: await _notificationPrefs.getMorningMinute(),
      eveningHour: await _notificationPrefs.getEveningHour(),
      eveningMinute: await _notificationPrefs.getEveningMinute(),
    );
  }

  @override
  Future<void> setEnabled({required bool enabled}) async {
    await _notificationPrefs.setEnabled(enabled);

    if (!enabled) {
      await NotificationService.cancel(NotificationConstants.morningNotification);
      await NotificationService.cancel(NotificationConstants.eveningNotification);
      return;
    }

    final hasPermission = await NotificationService.hasNotificationPermission();

    if (!hasPermission) {
      final granted = await NotificationService.requestPermissions();

      if (!granted) {
        await _notificationPrefs.setEnabled(false);
        return;
      }
    }

    if (await _notificationPrefs.getMorningEnabled()) {
      await NotificationService.cancel(NotificationConstants.morningNotification);
      await _scheduleMorningDaily();
    }

    if (await _notificationPrefs.getEveningEnabled()) {
      await NotificationService.cancel(NotificationConstants.eveningNotification);
      await _scheduleEveningDaily();
    }
  }

  @override
  Future<void> setEnabledMinute({required int minute}) async {
    await _notificationPrefs.setEnabledMinute(minute);
  }

  @override
  Future<void> setMorningEnabled({required bool enabled}) async {
    await _notificationPrefs.setMorningEnabled(enabled);
    if (!enabled) {
      await NotificationService.cancel(NotificationConstants.morningNotification);
    } else {
      await _scheduleMorningDaily();
    }
  }

  @override
  Future<void> setMorningTime({required int hour, required int minute}) async {
    await _notificationPrefs.setMorningTime(hour, minute);
    await NotificationService.cancel(NotificationConstants.morningNotification);
    if (await _notificationPrefs.getMorningEnabled()) {
      await _scheduleMorningDaily();
    }
  }

  @override
  Future<void> setEveningEnabled({required bool enabled}) async {
    await _notificationPrefs.setEveningEnabled(enabled);
    if (!enabled) {
      await NotificationService.cancel(NotificationConstants.eveningNotification);
    } else {
      await _scheduleEveningDaily();
    }
  }

  @override
  Future<void> setEveningTime({required int hour, required int minute}) async {
    await _notificationPrefs.setEveningTime(hour, minute);
    await NotificationService.cancel(NotificationConstants.eveningNotification);
    if (await _notificationPrefs.getEveningEnabled()) {
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

      final reminderMinutes = await _notificationPrefs.getEnabledMinute();

      final advanceTime = dateTime.subtract(Duration(minutes: reminderMinutes));
      final advanceId = Object.hash(task.id, Constants.advanceId);

      if (advanceTime.isAfter(DateTime.now()) && reminderMinutes != 0) {
        await NotificationService.showScheduleNotificationDateTime(
          id: advanceId,
          title: 'Coming soon: ${task.title}',
          body: task.description.isNotEmpty ? task.description : 'The task will start in $reminderMinutes min',
          dateTime: advanceTime,
          payload: task.id,
        );
      }

      final exactId = Object.hash(task.id, Constants.exactId);
      if (dateTime.isAfter(DateTime.now())) {
        await NotificationService.showScheduleNotificationDateTime(
          id: exactId,
          title: 'It is time! ${task.title}',
          body: task.description.isNotEmpty ? task.description : 'The task begins right now!',
          dateTime: dateTime,
          payload: task.id,
        );
      }
    } catch (e, s) {
      log('Error scheduling task reminder', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> restoreMorningNotification() async {
    if (!await _notificationPrefs.getMorningEnabled()) return;
    await _scheduleMorningDaily();
  }

  @override
  Future<void> restoreEveningNotification() async {
    if (!await _notificationPrefs.getEveningEnabled()) return;
    await _scheduleEveningDaily();
  }

  Future<void> _scheduleMorningDaily() async {
    final hour = await _notificationPrefs.getMorningHour();
    final minute = await _notificationPrefs.getMorningMinute();
    await NotificationService.showScheduleNotification(
      id: NotificationConstants.morningNotification,
      title: "Today’s tasks",
      body: "Check today's tasks",
      time: Time(hour, minute),
      payload: null,
    );
  }

  Future<void> _scheduleEveningDaily() async {
    final hour = await _notificationPrefs.getEveningHour();
    final minute = await _notificationPrefs.getEveningMinute();
    await NotificationService.showScheduleNotification(
      id: NotificationConstants.eveningNotification,
      title: "Daily summary",
      body: "What did you manage to accomplish today?",
      time: Time(hour, minute),
      payload: null,
    );
  }
}
