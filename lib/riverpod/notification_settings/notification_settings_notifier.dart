import 'package:flutter_app_todo/domain/entities/notification_settings_domain.dart';
import 'package:flutter_app_todo/domain/usecases/notification/load_settings_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/set_enabled_time_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/set_evening_time_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/set_morning_time_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/toggle_enabled_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/toggle_evening_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/notification/toggle_morning_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_settings_notifier.g.dart';

class NotificationSettingsState {
  const NotificationSettingsState({required this.notification, this.errorMessage, this.isLoading = false});

  const NotificationSettingsState.initial({
    this.notification = const NotificationSettingsDomain.empty(),
    this.errorMessage,
    this.isLoading = false,
  });

  final NotificationSettingsDomain notification;
  final String? errorMessage;
  final bool isLoading;

  NotificationSettingsState copyWith({
    NotificationSettingsDomain? notification,
    String? errorMessage,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      notification: notification ?? this.notification,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class NotificationSettingsVm extends _$NotificationSettingsVm {
  @override
  NotificationSettingsState build() {
    _load();
    return const NotificationSettingsState.initial();
  }

  Future<void> _load() async {
    try {
      final result = await ref.read(loadNotificationSettingsUseCaseProvider).execute();
      state = state.copyWith(notification: result);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleEnabled(bool value) async {
    state = state.copyWith(notification: state.notification.copyWith(enabled: value));

    try {
      await ref.read(toggleEnabledUseCaseProvider).call(value);

      await _load();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleMorning(bool value) async {
    state = state.copyWith(notification: state.notification.copyWith(morningEnabled: value));

    try {
      await ref.read(toggleMorningUseCaseProvider).call(value);
      await _load();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleEvening(bool value) async {
    state = state.copyWith(notification: state.notification.copyWith(eveningEnabled: value));

    try {
      await ref.read(toggleEveningUseCaseProvider).call(value);
      await _load();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> setMorningTime(int hour, int minute) async {
    state = state.copyWith(
      notification: state.notification.copyWith(morningHour: hour, morningMinute: minute),
    );

    try {
      final params = SetMorningTimeParams(hour: hour, minute: minute);
      await ref.read(setMorningTimeUseCaseProvider).call(params);
      await _load();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> setEveningTime(int hour, int minute) async {
    state = state.copyWith(
      notification: state.notification.copyWith(eveningHour: hour, eveningMinute: minute),
    );

    try {
      final params = SetEveningTimeParams(hour: hour, minute: minute);
      await ref.read(setEveningTimeUseCaseProvider).call(params);
      await _load();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> setReminderMinutes(int minutes) async {
    state = state.copyWith(notification: state.notification.copyWith(enabledMinute: minutes));

    try {
      await ref.read(setEnabledTimeUseCaseProvider).call(minutes);

      await _load();
    } catch (e) {
      await _load();
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
