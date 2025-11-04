import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/task/delete_task_by_id_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_tasks_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/update_task_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_notifier.g.dart';

class TasksState {
  const TasksState({required this.tasks, required this.selectedIndex});
  final List<TaskDomain> tasks;
  final int selectedIndex;

  TasksState copyWith({List<TaskDomain>? tasks, int? selectedIndex}) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

@riverpod
class TasksVm extends _$TasksVm {
  GetTasksUseCase get _getAll => ref.read(getTasksUseCaseProvider);
  UpdateTaskUseCase get _update => ref.read(updateTaskUseCaseProvider);
  DeleteTaskByIdUseCase get _delete => ref.read(deleteTaskByIdUseCaseProvider);

  @override
  Future<TasksState> build() async {
    final tasks = await _getAll.execute();
    return TasksState(tasks: tasks, selectedIndex: 0);
  }

  void selectFilter(int index) {
    final current = state.requireValue;
    state = AsyncValue.data(current.copyWith(selectedIndex: index));
  }

  Future<void> deleteById(String id) async {
    await _delete(id);
    final currentState = state.requireValue;
    final tasks = [...currentState.tasks]..removeWhere((e) => e.id == id);
    state = AsyncValue.data(currentState.copyWith(tasks: tasks));
  }

  Future<void> toggleComplete(String id) async {
    final currentState = state.requireValue;

    final tasks = [...currentState.tasks];
    final index = tasks.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final updated = tasks[index].copyWith(
      isCompleted: !tasks[index].isCompleted,
    );
    await _update(updated);

    tasks[index] = updated;
    state = AsyncValue.data(currentState.copyWith(tasks: tasks));
  }

  Future<void> refresh() async {
    final result = await _getAll.execute();
    final currentState = state.requireValue;
    state = AsyncValue.data(currentState.copyWith(tasks: result));
  }
}
