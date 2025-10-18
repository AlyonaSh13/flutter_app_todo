import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/task/delete_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/update_task_usecase.dart';
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

  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider)(id);
    await loadTasks();
  }

  Future<void> toggleComplete(int index) async {
    final tasks = state.requireValue;
    final task = tasks[index];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await ref.read(updateTaskUseCaseProvider).call(updatedTask);
    await loadTasks();
  }
}
