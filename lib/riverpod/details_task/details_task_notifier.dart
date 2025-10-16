import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/utils/date_time_extension.dart';
import 'package:flutter_app_todo/domain/usecase/task/update_task_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_app_todo/domain/task_domain.dart';

part 'details_task_notifier.g.dart';

class DetailsTaskState {
  const DetailsTaskState({
    required this.task,
    required this.index,
    required this.isEditing,
  });

  final TaskDomain task;
  final int index;
  final bool isEditing;

  DetailsTaskState copyWith({TaskDomain? task, int? index, bool? isEditing}) {
    return DetailsTaskState(
      task: task ?? this.task,
      index: index ?? this.index,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class DetailsTaskVmParams {
  const DetailsTaskVmParams({required this.task, required this.index});

  final TaskDomain task;
  final int index;
}

@riverpod
class DetailsTaskVm extends _$DetailsTaskVm {
  @override
  DetailsTaskState build(DetailsTaskVmParams params) {
    return DetailsTaskState(
      task: params.task,
      index: params.index,
      isEditing: false,
    );
  }

  void toggleEdit() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void updateTitle(String title) {
    final task = state.task.copyWith(title: title);
    state = state.copyWith(task: task);
  }

  void updateDescription(String description) {
    final task = state.task.copyWith(description: description);
    state = state.copyWith(task: task);
  }

  void updateDate(DateTime date) {
    final task = state.task.copyWith(date: date.formatDayMonthYear());
    state = state.copyWith(task: task);
  }

  void updateTime(TimeOfDay time, BuildContext context) {
    final task = state.task.copyWith(time: time.format(context));
    state = state.copyWith(task: task);
  }

  void toggleComplete() {
    final task = state.task.copyWith(isCompleted: !state.task.isCompleted);
    state = state.copyWith(task: task);
  }

  Future<void> saveChanges() async {
    await ref
        .read(updateTaskUseCaseProvider)
        .call(UpdateTaskParams(index: state.index, task: state.task));

    state = state.copyWith(isEditing: false);
  }
}
