import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/notification/load_settings_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/add_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/schedule_task_reminder_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'creation_task_notifier.g.dart';

class CreationTaskState {
  const CreationTaskState({required this.task, required this.isSuccess, this.errorMessage});

  const CreationTaskState.initial({this.isSuccess = false, this.task = const TaskDomain.empty(), this.errorMessage});

  final TaskDomain task;
  final bool isSuccess;
  final String? errorMessage;

  CreationTaskState copyWith({TaskDomain? task, bool? isSuccess, String? errorMessage}) {
    return CreationTaskState(
      task: task ?? this.task,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class CreationTaskVm extends _$CreationTaskVm {
  @override
  CreationTaskState build() {
    return const CreationTaskState.initial();
  }

  Future<void> addTask(TaskDomain task) async {
    try {
      final id = await ref.read(addTaskUseCaseProvider).call(task);
      final updatedTask = task.copyWith(id: id);

      final result = await ref.read(loadNotificationSettingsUseCaseProvider).execute();
      final canScheduleTask = updatedTask.date.toDateTimeDMY() != null;

      if (result.enabled && canScheduleTask) {
        await ref.read(scheduleTaskReminderUseCaseProvider).call(updatedTask);
      }

      state = state.copyWith(isSuccess: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void updateTask(TaskDomain task) {
    state = state.copyWith(task: task);
  }

  void updateDate(String date) {
    state = state.copyWith(task: state.task.copyWith(date: date));
  }

  void updateTime(String time) {
    state = state.copyWith(task: state.task.copyWith(time: time));
  }

  void reset() {
    state = const CreationTaskState.initial();
  }
}
