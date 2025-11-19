import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/riverpod/notification_settings/notification_settings_notifier.dart';
import 'package:flutter_app_todo/widget/button/button_widget.dart';
import 'package:flutter_app_todo/widget/button/switch_setting_widget.dart';
import 'package:flutter_app_todo/widget/card/card_setting_widget.dart';
import 'package:flutter_app_todo/widget/scaffold_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(notificationSettingsVmProvider.notifier);
    final state = ref.watch(notificationSettingsVmProvider);

    final notifications = state.notification;

    return ScaffoldWidget(
      appBar: AppBar(
        title: const Text('Notifications', style: AppTextStyle.bold18),
        centerTitle: true,
        backgroundColor: AppColors.colorSkyMist,
        iconTheme: const IconThemeData(color: AppColors.colorDeepBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          _SwitchSettingTile(
            icon: Icons.notifications_active_outlined,
            title: 'Enable notifications',
            subtitle: 'Allows you to enable or disable notifications for a task',
            value: notifications.enabled,
            onChanged: (value) {
              vm.toggleEnabled(value);
            },
          ),

          if (notifications.enabled) ...[
            _ReminderMinutesSettingTile(
              currentMinutes: notifications.enabledMinute,
              onMinutesChanged: (value) {
                vm.setReminderMinutes(value);
              },
              enabled: notifications.enabled,
            ),

            _TimeSwitchSettingTile(
              icon: Icons.wb_sunny_outlined,
              title: 'Morning overview',
              subtitle: 'Notification in the morning at the selected time.',
              hour: notifications.morningHour,
              minute: notifications.morningMinute,
              switchValue: notifications.morningEnabled,
              onTimeSelected: vm.setMorningTime,
              onSwitchChanged: (value) {
                vm.toggleMorning(value);
              },
            ),

            _TimeSwitchSettingTile(
              icon: Icons.nightlight_round_outlined,
              title: 'Evening summary',
              subtitle: 'Evening report on completed tasks.',
              hour: notifications.eveningHour,
              minute: notifications.eveningMinute,
              switchValue: notifications.eveningEnabled,
              onTimeSelected: vm.setEveningTime,
              onSwitchChanged: (value) {
                vm.toggleEvening(value);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SwitchSettingTile extends StatelessWidget {
  const _SwitchSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CardSettingWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: SwitchSettingWidget(value: value, onChanged: onChanged),
    );
  }
}

class _ReminderMinutesSettingTile extends StatelessWidget {
  const _ReminderMinutesSettingTile({
    required this.currentMinutes,
    required this.onMinutesChanged,
    this.enabled = true,
  });

  final int currentMinutes;
  final void Function(int minutes) onMinutesChanged;
  final bool enabled;

  static const List<int> _minutes = [0, 5, 10, 15, 30, 60];

  static String _displayText(int minutes) {
    return switch (minutes) {
      0 => 'At time',
      60 => '1 hour',
      _ => '$minutes min',
    };
  }

  @override
  Widget build(BuildContext context) {
    return CardSettingWidget(
      icon: Icons.alarm_outlined,
      title: 'Remind before task',
      subtitle: 'Notification will arrive before the task starts.',
      enabled: enabled,
      trailing: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: enabled ? AppColors.colorOceanBlue : AppColors.colorLightGray, width: 1.2),
          ),
          child: DropdownButton<int>(
            value: currentMinutes,
            underline: const SizedBox.shrink(),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: enabled ? AppColors.colorOceanBlue : AppColors.colorLightGray,
            ),
            style: AppTextStyle.medium14.copyWith(color: enabled ? AppColors.colorOceanBlue : AppColors.colorLightGray),
            dropdownColor: AppColors.colorPureWhite,
            borderRadius: BorderRadius.circular(14),
            elevation: 4,
            isDense: true,
            menuMaxHeight: 280,
            items: _minutes.map((minutes) {
              return DropdownMenuItem(
                value: minutes,
                child: Text(_displayText(minutes), style: AppTextStyle.medium16),
              );
            }).toList(),
            onChanged: enabled
                ? (value) {
                    if (value != null && value != currentMinutes) {
                      onMinutesChanged(value);
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

class _TimeSwitchSettingTile extends StatelessWidget {
  const _TimeSwitchSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.hour,
    required this.minute,
    required this.switchValue,
    required this.onTimeSelected,
    required this.onSwitchChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  final int hour;
  final int minute;

  final bool switchValue;

  final void Function(int hour, int minute) onTimeSelected;
  final ValueChanged<bool> onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    return CardSettingWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Column(
        children: [
          SwitchSettingWidget(value: switchValue, onChanged: onSwitchChanged),
          const SizedBox(height: 12),
          ButtonWidget(
            title: "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
            textStyle: AppTextStyle.light14,
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
              );
              if (time != null) {
                onTimeSelected(time.hour, time.minute);
              }
            },
            backgroundColor: AppColors.colorPureWhite,
            foregroundColor: AppColors.colorOceanBlue,
            side: const BorderSide(color: AppColors.colorOceanBlue),
          ),
        ],
      ),
    );
  }
}
