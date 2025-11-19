import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo/domain/usecases/notification/load_settings_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_task_by_id_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/schedule_task_reminder_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/task/update_task_usecase.dart';

part 'details_task_notifier.g.dart';

class DetailsTaskState {
  const DetailsTaskState({required this.task, required this.isEditing});

  final TaskDomain task;
  final bool isEditing;

  DetailsTaskState copyWith({TaskDomain? task, bool? isEditing}) {
    return DetailsTaskState(task: task ?? this.task, isEditing: isEditing ?? this.isEditing);
  }
}

class DetailsTaskVmParams extends Equatable {
  const DetailsTaskVmParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

@riverpod
class DetailsTaskVm extends _$DetailsTaskVm {
  @override
  Future<DetailsTaskState> build(DetailsTaskVmParams params) async {
    final task = await ref.read(getTaskByIdUseCaseProvider).execute(params.id);

    if (task == null) {
      return const DetailsTaskState(task: TaskDomain.empty(), isEditing: false);
    }
    return DetailsTaskState(task: task, isEditing: false);
  }

  void toggleEdit() {
    state = AsyncData(state.requireValue.copyWith(isEditing: !state.requireValue.isEditing));
  }

  void updateTitle(String title) {
    final task = state.requireValue.task.copyWith(title: title);
    state = AsyncData(state.requireValue.copyWith(task: task));
  }

  void updateDescription(String description) {
    final task = state.requireValue.task.copyWith(description: description);
    state = AsyncData(state.requireValue.copyWith(task: task));
  }

  void updateDate(DateTime date) {
    final task = state.requireValue.task.copyWith(date: date.formatDayMonthYear());
    state = AsyncData(state.requireValue.copyWith(task: task));
  }

  void updateTime(TimeOfDay time, BuildContext context) {
    final task = state.requireValue.task.copyWith(time: time.format(context));
    state = AsyncData(state.requireValue.copyWith(task: task));
  }

  void toggleComplete() {
    final task = state.requireValue.task.copyWith(isCompleted: !state.requireValue.task.isCompleted);
    state = AsyncData(state.requireValue.copyWith(task: task));
  }

  Future<TaskDomain?> saveChanges() async {
    final task = state.requireValue.task;
    await ref.read(updateTaskUseCaseProvider).call(task);

    final result = await ref.read(loadNotificationSettingsUseCaseProvider).execute();
    final canScheduleTask = task.date.toDateTimeDMY() != null;

    if (result.enabled && canScheduleTask) {
      await ref.read(scheduleTaskReminderUseCaseProvider).call(task);
    }

    state = AsyncData(state.requireValue.copyWith(isEditing: false));
    return task;
  }
}
