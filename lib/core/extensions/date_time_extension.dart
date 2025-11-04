import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatFullDayMonth() =>
      DateFormat(DateFormats.fullDayMonth).format(this);

  String formatDayMonthYear() =>
      DateFormat(DateFormats.dayMonthYear).format(this);

  String formatHourMinute() => DateFormat(DateFormats.hourMinute).format(this);

  bool isSameDay(DateTime b) =>
      year == b.year && month == b.month && day == b.day;
}

extension StringToDateTimeExtension on String {
  DateTime? toDateTimeDMY() {
    if (trim().isEmpty) return null;
    try {
      return DateFormat(DateFormats.dayMonthYear).parseStrict(this);
    } catch (_) {
      return null;
    }
  }
}
