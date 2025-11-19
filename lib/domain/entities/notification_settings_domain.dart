import 'package:equatable/equatable.dart';

class NotificationSettingsDomain extends Equatable {
  const NotificationSettingsDomain({
    required this.enabled,
    required this.enabledMinute,
    required this.morningEnabled,
    required this.eveningEnabled,
    required this.morningHour,
    required this.morningMinute,
    required this.eveningHour,
    required this.eveningMinute,
  });

  const NotificationSettingsDomain.empty({
    this.enabled = false,
    this.enabledMinute = 5,
    this.morningEnabled = false,
    this.eveningEnabled = false,
    this.morningHour = 8,
    this.morningMinute = 0,
    this.eveningHour = 21,
    this.eveningMinute = 0,
  });

  final bool enabled;
  final int enabledMinute;
  final bool morningEnabled;
  final bool eveningEnabled;

  final int morningHour;
  final int morningMinute;
  final int eveningHour;
  final int eveningMinute;

  NotificationSettingsDomain copyWith({
    bool? enabled,
    int? enabledMinute,
    bool? morningEnabled,
    bool? eveningEnabled,
    int? morningHour,
    int? morningMinute,
    int? eveningHour,
    int? eveningMinute,
  }) {
    return NotificationSettingsDomain(
      enabled: enabled ?? this.enabled,
      enabledMinute: enabledMinute ?? this.enabledMinute,
      morningEnabled: morningEnabled ?? this.morningEnabled,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
    );
  }

  @override
  List<Object> get props => [
    enabled,
    enabledMinute,
    morningEnabled,
    eveningEnabled,
    morningHour,
    morningMinute,
    eveningHour,
    eveningMinute,
  ];
}
