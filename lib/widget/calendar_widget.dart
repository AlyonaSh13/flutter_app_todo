import 'package:flutter/material.dart';
import 'package:flutter_app_todo/widget/ink_well_material_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.countMap,
    required this.format,
    required this.onFormatChanged,
    required this.onDaySelected,
  });

  final DateTime selectedDate;
  final Map<String, int> countMap;
  final CalendarFormat format;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 12 : 0,
            vertical: 8,
          ),
          child: TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2050),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: format,
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onFormatChanged: onFormatChanged,
            onDaySelected: (day, _) => onDaySelected(day),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: const BoxDecoration(
                color: AppColors.colorSkyMist,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              formatButtonTextStyle: AppTextStyle.medium14.copyWith(
                color: AppColors.colorSteelBlue,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: AppColors.colorSteelBlue,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: AppColors.colorSteelBlue,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: AppTextStyle.regular14.copyWith(
                color: AppColors.colorSoftRed,
              ),
              weekdayStyle: AppTextStyle.regular14.copyWith(
                color: AppColors.colorDeepBlue,
              ),
            ),

            calendarStyle: CalendarStyle(
              weekendTextStyle: const TextStyle(color: AppColors.colorSoftRed),
              todayDecoration: BoxDecoration(
                color: AppColors.colorOceanBlue.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.colorOceanBlue,
                shape: BoxShape.circle,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final isSelected = isSameDay(date, selectedDate);
                final isToday = isSameDay(date, DateTime.now());
                final textColor = date.weekday >= 6
                    ? AppColors.colorSoftRed
                    : AppColors.colorDeepBlue;

                return Center(
                  child: Material(
                    color: isSelected
                        ? AppColors.colorOceanBlue
                        : isToday
                        ? AppColors.colorOceanBlue.withValues(alpha: 0.25)
                        : Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWellMaterialWidget(
                      onTap: () => onDaySelected(date),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: TextWidget(
                            '${date.day}',
                            style: AppTextStyle.regular14.copyWith(
                              color: isSelected
                                  ? AppColors.colorPureWhite
                                  : textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },

              markerBuilder: (context, date, _) {
                final formatted = date.formatDayMonthYear();
                final count = countMap[formatted] ?? 0;
                if (count == 0) return const SizedBox.shrink();

                return Positioned(
                  right: 5,
                  bottom: 1,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.colorDeepBlue,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: TextWidget(
                      '$count',
                      style: AppTextStyle.regular14.copyWith(
                        fontSize: 12,
                        color: AppColors.colorPureWhite,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
