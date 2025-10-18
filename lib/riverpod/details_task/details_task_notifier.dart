// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    return DetailsTaskState(
      task: task ?? this.task,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class DetailsTaskVmParams extends Equatable {
  const DetailsTaskVmParams({required this.task});

  final TaskDomain task;

  @override
  List<Object> get props => [task];
}

@riverpod
class DetailsTaskVm extends _$DetailsTaskVm {
  @override
  DetailsTaskState build(DetailsTaskVmParams params) {
    return DetailsTaskState(task: params.task, isEditing: false);
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
    await ref.read(updateTaskUseCaseProvider).call(state.task);

    state = state.copyWith(isEditing: false);
  }
}
