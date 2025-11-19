import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/data/database/database.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_app_todo/data/services/notification_service.dart';
import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<TaskRepository> taskRepositoryProvider = Provider((ref) {
  final db = ref.watch(AppDatabase.provider);
  final notificationRepo = ref.watch(notificationRepositoryProvider);
  return DriftTaskRepositoryImpl(db, notificationRepo);
});

extension NullableStringValue on String? {
  Value<String> toDriftValue() => this != null && this!.trim().isNotEmpty ? Value(this!) : const Value.absent();
}

abstract class TaskRepository {
  Future<String> addTask({required TaskDomain task});
  Future<void> updateTask({required TaskDomain task});
  Future<void> deleteTaskById({required String id});
  Future<List<TaskDomain>> getTasks();
  Future<TaskDomain?> getTaskById({required String id});
  Future<List<TaskDomain>> getTasksByDate({required String date});
}

class DriftTaskRepositoryImpl implements TaskRepository {
  DriftTaskRepositoryImpl(this._db, this._notificationRepository);

  final AppDatabase _db;
  final NotificationRepository _notificationRepository;

  Future<void> _cancelTaskReminders(TaskDomain task) async {
    final advanceId = Object.hash(task.id, Constants.advanceId);
    final exactId = Object.hash(task.id, Constants.exactId);

    await NotificationService.cancel(advanceId);
    await NotificationService.cancel(exactId);
  }

  @override
  Future<String> addTask({required TaskDomain task}) async {
    final companion = TasksCompanion(
      title: Value(task.title),
      description: Value(task.description),
      date: task.date.toDriftValue(),
      time: task.time.toDriftValue(),
      category: Value(task.category.name),
      isCompleted: Value(task.isCompleted),
    );

    final inserted = await _db.insertTask(companion);
    final newTask = task.copyWith(id: inserted.id);

    if (newTask.hasDateTime) {
      final settings = await _notificationRepository.loadSettings();
      if (settings.enabled) {
        await _notificationRepository.scheduleTaskReminder(task: newTask);
      }
    }

    return inserted.id;
  }

  @override
  Future<void> updateTask({required TaskDomain task}) async {
    await _cancelTaskReminders(task);

    await _db.updateTaskById(
      TasksCompanion(
        id: Value(task.id),
        title: Value(task.title),
        description: Value(task.description),
        date: task.date.toDriftValue(),
        time: task.time.toDriftValue(),
        category: Value(task.category.name),
        isCompleted: Value(task.isCompleted),
      ),
    );

    if (task.hasDateTime) {
      final settings = await _notificationRepository.loadSettings();
      if (settings.enabled) {
        await _notificationRepository.scheduleTaskReminder(task: task);
      }
    }
  }

  @override
  Future<void> deleteTaskById({required String id}) async {
    final task = await getTaskById(id: id);
    if (task != null && task.hasDateTime) {
      await _cancelTaskReminders(task);
    }
    await _db.deleteTaskById(id);
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
        (category) => category.name.trim().toLowerCase() == task.category.trim().toLowerCase(),
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
              (category) => category.name.trim().toLowerCase() == t.category.trim().toLowerCase(),
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
