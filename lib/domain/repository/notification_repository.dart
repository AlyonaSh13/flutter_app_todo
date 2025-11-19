import 'package:flutter_app_todo/domain/entities/notification_settings_domain.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';

abstract class NotificationRepository {
  Future<NotificationSettingsDomain> loadSettings();
  Future<void> setEnabled({required bool enabled});
  Future<void> setEnabledMinute({required int minute});
  Future<void> setMorningEnabled({required bool enabled});
  Future<void> setEveningEnabled({required bool enabled});
  Future<void> setMorningTime({required int hour, required int minute});
  Future<void> setEveningTime({required int hour, required int minute});
  Future<void> scheduleTaskReminder({required TaskDomain task});
  Future<void> restoreMorningNotification();
  Future<void> restoreEveningNotification();
}
