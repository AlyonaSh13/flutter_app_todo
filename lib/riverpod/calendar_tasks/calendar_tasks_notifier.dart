import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_tasks_by_date_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_tasks_usecase.dart';

part 'calendar_tasks_notifier.g.dart';

class CalendarTasksState {
  const CalendarTasksState({
    required this.selectedDate,
    required this.tasks,
    required this.calendarMap,
  });
  final DateTime selectedDate;
  final List<TaskDomain> tasks;
  final Map<String, int> calendarMap;

  CalendarTasksState copyWith({
    DateTime? selectedDate,
    List<TaskDomain>? tasks,
    Map<String, int>? calendarMap,
  }) {
    return CalendarTasksState(
      selectedDate: selectedDate ?? this.selectedDate,
      tasks: tasks ?? this.tasks,
      calendarMap: calendarMap ?? this.calendarMap,
    );
  }
}

@riverpod
class CalendarTasksVm extends _$CalendarTasksVm {
  GetTasksUseCase get _getAll => ref.read(getTasksUseCaseProvider);
  GetTasksByDateUseCase get _getByDate =>
      ref.read(getTasksByDateUseCaseProvider);

  @override
  Future<CalendarTasksState> build() async {
    final now = DateTime.now();

    final tasksByDate = await _getByDate.execute(now.formatDayMonthYear());

    final allTasks = await _getAll.execute();
    final calendarMap = <String, int>{};

    for (final task in allTasks) {
      final date = task.date.toDateTimeDMY();
      if (date == null) continue;
      final formatted = date.formatDayMonthYear();
      calendarMap[formatted] = (calendarMap[formatted] ?? 0) + 1;
    }

    return CalendarTasksState(
      calendarMap: calendarMap,
      selectedDate: now,
      tasks: tasksByDate,
    );
  }

  Future<void> selectDate(DateTime date) async {
    final current = state.requireValue;
    state = AsyncValue.data(current.copyWith(selectedDate: date));
    await refresh();
  }

  Future<void> refresh() async {
    final currentState = state.requireValue;

    final tasksByDate = await _getByDate.execute(
      currentState.selectedDate.formatDayMonthYear(),
    );

    final allTasks = await _getAll.execute();
    final calendarMap = <String, int>{};

    for (final task in allTasks) {
      final date = task.date.toDateTimeDMY();
      if (date == null) continue;
      final formatted = date.formatDayMonthYear();
      calendarMap[formatted] = (calendarMap[formatted] ?? 0) + 1;
    }

    state = AsyncValue.data(
      currentState.copyWith(calendarMap: calendarMap, tasks: tasksByDate),
    );
  }
}
