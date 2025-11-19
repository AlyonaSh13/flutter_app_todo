import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatFullDayMonth() => DateFormat(Constants.fullDayMonth).format(this);

  String formatDayMonthYear() => DateFormat(Constants.dayMonthYear).format(this);

  String formatHourMinute() => DateFormat(Constants.hourMinute).format(this);

  bool isSameDay(DateTime b) => year == b.year && month == b.month && day == b.day;
}

extension StringToDateTimeExtension on String? {
  DateTime? toDateTimeDMY() {
    final str = this?.trim();
    if (str == null || str.isEmpty) return null;

    try {
      return DateFormat(Constants.dayMonthYear).parseStrict(str);
    } catch (_) {
      return null;
    }
  }

  DateTime? toTimeOfDay() {
    final str = this?.trim();
    if (str == null || str.isEmpty || !str.contains(':')) return null;

    final parts = str.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return DateTime(2000, 1, 1, hour, minute);
  }
}

DateTime? combineDateAndTime(String? date, String? time) {
  final datePart = date?.toDateTimeDMY();
  final timePart = time?.toTimeOfDay();

  if (datePart == null || timePart == null) {
    return null;
  }

  return DateTime(datePart.year, datePart.month, datePart.day, timePart.hour, timePart.minute);
}
