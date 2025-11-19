import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationPrefsProvider = Provider<NotificationPrefs>((ref) => NotificationPrefs());

class NotificationPrefs {
  NotificationPrefs();

  static const _kEnabled = 'notification_enabled';
  static const _kEnabledMinute = 'notification_enabled_minute';

  static const _kMorningEnabled = 'notification_morning_enabled';
  static const _kEveningEnabled = 'notification_evening_enabled';

  static const _kMorningHour = 'notification_morning_hour';
  static const _kMorningMinute = 'notification_morning_minute';
  static const _kEveningHour = 'notification_evening_hour';
  static const _kEveningMinute = 'notification_evening_minute';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool> getEnabled() async => (await _prefs).getBool(_kEnabled) ?? false;
  Future<void> setEnabled(bool value) async => (await _prefs).setBool(_kEnabled, value);

  Future<int> getEnabledMinute() async => (await _prefs).getInt(_kEnabledMinute) ?? 5;
  Future<void> setEnabledMinute(int minute) async {
    final p = await _prefs;
    await p.setInt(_kEnabledMinute, minute);
  }

  Future<bool> getMorningEnabled() async => (await _prefs).getBool(_kMorningEnabled) ?? false;
  Future<void> setMorningEnabled(bool value) async => (await _prefs).setBool(_kMorningEnabled, value);

  Future<bool> getEveningEnabled() async => (await _prefs).getBool(_kEveningEnabled) ?? false;
  Future<void> setEveningEnabled(bool value) async => (await _prefs).setBool(_kEveningEnabled, value);

  Future<int> getMorningHour() async => (await _prefs).getInt(_kMorningHour) ?? 8;
  Future<int> getMorningMinute() async => (await _prefs).getInt(_kMorningMinute) ?? 0;
  Future<void> setMorningTime(int hour, int minute) async {
    final p = await _prefs;
    await p.setInt(_kMorningHour, hour);
    await p.setInt(_kMorningMinute, minute);
  }

  Future<int> getEveningHour() async => (await _prefs).getInt(_kEveningHour) ?? 21;
  Future<int> getEveningMinute() async => (await _prefs).getInt(_kEveningMinute) ?? 0;
  Future<void> setEveningTime(int hour, int minute) async {
    final p = await _prefs;
    await p.setInt(_kEveningHour, hour);
    await p.setInt(_kEveningMinute, minute);
  }
}
