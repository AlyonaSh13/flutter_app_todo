import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/usecases/task/delete_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/get_task_usecase.dart';
import 'package:flutter_app_todo/domain/usecases/task/update_task_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_task_notifier.g.dart';

class GroupTaskState {
  const GroupTaskState({required this.tasks, required this.selectedIndex});

  final List<TaskDomain> tasks;
  final int selectedIndex;

  GroupTaskState copyWith({List<TaskDomain>? tasks, int? selectedIndex}) {
    return GroupTaskState(
      tasks: tasks ?? this.tasks,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

@riverpod
class GroupTaskVm extends _$GroupTaskVm {
  @override
  Future<GroupTaskState> build() async {
    final data = await ref.read(getTaskUseCaseProvider).execute();
    return GroupTaskState(tasks: data, selectedIndex: 0);
  }

  Future<void> loadTasks() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final tasks = await ref.read(getTaskUseCaseProvider).execute();
      return GroupTaskState(
        tasks: tasks,
        selectedIndex: state.requireValue.selectedIndex,
      );
    });
  }

  void selectFilter(int index) {
    final current = state.requireValue;
    state = AsyncValue.data(current.copyWith(selectedIndex: index));
  }

  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider)(id);
    await loadTasks();
  }

  Future<void> toggleComplete(String id) async {
    final current = state.requireValue;
    final tasks = current.tasks;
    final task = tasks.firstWhere((e) => e.id == id);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await ref.read(updateTaskUseCaseProvider).call(updatedTask);
    await loadTasks();
  }
}
