import 'package:flutter_app_todo/domain/entities/task_domain.dart';

abstract class TaskRepository {
  Future<String> addTask({required TaskDomain task});
  Future<void> updateTask({required TaskDomain task});
  Future<void> deleteTaskById({required String id});
  Future<List<TaskDomain>> getTasks();
  Future<TaskDomain?> getTaskById({required String id});
  Future<List<TaskDomain>> getTasksByDate({required String date});
}
