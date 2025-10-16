import 'package:flutter_app_todo/domain/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<TaskRepository> taskRepositoryProvider = Provider(
  (ref) => TaskRepositoryImpl(),
);

abstract class TaskRepository {
  Future<void> addTask({required TaskDomain task});
  Future<void> updateTask({required int index, required TaskDomain task});
  Future<void> deleteTask({required int index});
  Future<List<TaskDomain>> getTasks();
}

final List<TaskDomain> _tasks = [];

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> addTask({required TaskDomain task}) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask({
    required int index,
    required TaskDomain task,
  }) async {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = task;
    } else {
      return;
    }
  }

  @override
  Future<void> deleteTask({required int index}) async {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    } else {
      throw Exception('Invalid task index');
    }
  }

  @override
  Future<List<TaskDomain>> getTasks() async {
    return [..._tasks];
  }
}
