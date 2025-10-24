import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final Provider<TaskRepository> taskRepositoryProvider = Provider(
  (ref) => TaskRepositoryImpl(),
);

abstract class TaskRepository {
  Future<void> addTask({required TaskDomain task});
  Future<void> updateTask({required TaskDomain task});
  Future<void> deleteTask({required String id});
  Future<List<TaskDomain>> getTasks();
  Future<TaskDomain> getTaskById({required String id});
}

List<TaskDomain> _tasks = [];

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> addTask({required TaskDomain task}) async {
    _tasks.add(task.copyWith(id: const Uuid().v4()));
  }

  @override
  Future<void> updateTask({required TaskDomain task}) async {
    _tasks = _tasks.map((e) {
      if (e.id == task.id) {
        return task;
      }
      return e;
    }).toList();
  }

  @override
  Future<void> deleteTask({required String id}) async {
    _tasks.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<TaskDomain>> getTasks() async {
    return [..._tasks];
  }

  @override
  Future<TaskDomain> getTaskById({required String id}) async {
    return _tasks.firstWhere((e) => e.id == id);
  }
}
