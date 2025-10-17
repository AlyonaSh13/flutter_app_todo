import 'package:flutter_app_todo/domain/task_domain.dart';
import 'package:flutter_app_todo/domain/usecase/task/delete_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecase/task/get_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecase/task/update_task_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_notifier.g.dart';

@riverpod
class TasksVm extends _$TasksVm {
  @override
  Future<List<TaskDomain>> build() async {
    return await ref.read(getTaskUseCaseProvider).execute();
  }

  Future<void> loadTasks() async {
    state = await AsyncValue.guard(
      () => ref.read(getTaskUseCaseProvider).execute(),
    );
  }

  Future<void> deleteTask(int index) async {
    await ref.read(deleteTaskUseCaseProvider)(index);
    await loadTasks();
  }

  Future<void> toggleComplete(int index) async {
    final tasks = state.requireValue;
    final task = tasks[index];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await ref
        .read(updateTaskUseCaseProvider)
        .call(UpdateTaskParams(index: index, task: updatedTask));
    await loadTasks();
  }
}
