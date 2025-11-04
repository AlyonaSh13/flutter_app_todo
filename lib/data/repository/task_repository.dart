import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter_app_todo/data/database/database.dart';
import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<TaskRepository> taskRepositoryProvider = Provider((ref) {
  final db = ref.watch(AppDatabase.provider);
  return DriftTaskRepositoryImpl(db);
});

abstract class TaskRepository {
  Future<void> addTask({required TaskDomain task});
  Future<void> updateTask({required TaskDomain task});
  Future<void> deleteTaskById({required String id});
  Future<List<TaskDomain>> getTasks();
  Future<TaskDomain?> getTaskById({required String id});
  Future<List<TaskDomain>> getTasksByDate({required String date});
}

class DriftTaskRepositoryImpl implements TaskRepository {
  DriftTaskRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> addTask({required TaskDomain task}) async {
    await _db.insertTask(
      TasksCompanion.insert(
        title: task.title,
        description: task.description,
        date: task.date,
        time: task.time,
        category: task.category.name,
        isCompleted: Value(task.isCompleted),
      ),
    );
  }

  @override
  Future<void> updateTask({required TaskDomain task}) async {
    await _db.updateTaskById(
      TasksCompanion(
        id: Value(task.id),
        title: Value(task.title),
        description: Value(task.description),
        date: Value(task.date),
        time: Value(task.time),
        category: Value(task.category.name),
        isCompleted: Value(task.isCompleted),
      ),
    );
  }

  @override
  Future<void> deleteTaskById({required String id}) {
    return _db.deleteTaskById(id);
  }

  @override
  Future<List<TaskDomain>> getTasks() async {
    final data = await _db.getAllTasks();

    return data
        .map(
          (e) => TaskDomain(
            id: e.id,
            title: e.title,
            description: e.description,
            date: e.date,
            time: e.time,
            category: TaskCategory.values.firstWhere(
              (category) => category.name == e.category,
              orElse: () {
                log('Unknown category: ${e.category}');
                return TaskCategory.none;
              },
            ),
            isCompleted: e.isCompleted,
          ),
        )
        .toList();
  }

  @override
  Future<TaskDomain?> getTaskById({required String id}) async {
    final task = await _db.getTaskById(id);
    if (task == null) return null;

    return TaskDomain(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      time: task.time,
      category: TaskCategory.values.firstWhere(
        (category) =>
            category.name.trim().toLowerCase() ==
            task.category.trim().toLowerCase(),
        orElse: () => TaskCategory.none,
      ),
      isCompleted: task.isCompleted,
    );
  }

  @override
  Future<List<TaskDomain>> getTasksByDate({required String date}) async {
    final tasks = await _db.getTasksByDate(date);
    return tasks
        .map(
          (t) => TaskDomain(
            id: t.id,
            title: t.title,
            description: t.description,
            category: TaskCategory.values.firstWhere(
              (category) =>
                  category.name.trim().toLowerCase() ==
                  t.category.trim().toLowerCase(),
              orElse: () => TaskCategory.none,
            ),
            date: t.date,
            time: t.time,
            isCompleted: t.isCompleted,
          ),
        )
        .toList();
  }
}
