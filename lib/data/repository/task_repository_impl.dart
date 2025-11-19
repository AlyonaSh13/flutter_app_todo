import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/data/database/database.dart';
import 'package:flutter_app_todo/data/database/table_task.dart';
import 'package:flutter_app_todo/data/repository/notification_repository_impl.dart';
import 'package:flutter_app_todo/data/services/notification_service.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/repository/notification_repository.dart';
import 'package:flutter_app_todo/domain/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<TaskRepository> taskRepositoryProvider = Provider((ref) {
  final db = ref.watch(AppDatabase.provider);
  final notificationRepo = ref.watch(notificationRepositoryProvider);
  return DriftTaskRepositoryImpl(db, notificationRepo);
});

class DriftTaskRepositoryImpl implements TaskRepository {
  DriftTaskRepositoryImpl(this._db, this._notificationRepository);

  final AppDatabase _db;
  final NotificationRepository _notificationRepository;

  @override
  Future<String> addTask({required TaskDomain task}) async {
    final inserted = await _db.insertTask(task.toBody());
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

    await _db.updateTaskById(task.toBody());

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

    return data.map((e) => e.toDomain()).toList();
  }

  @override
  Future<TaskDomain?> getTaskById({required String id}) async {
    final task = await _db.getTaskById(id);
    if (task == null) return null;

    return task.toDomain();
  }

  @override
  Future<List<TaskDomain>> getTasksByDate({required String date}) async {
    final tasks = await _db.getTasksByDate(date);
    return tasks.map((t) => t.toDomain()).toList();
  }

  Future<void> _cancelTaskReminders(TaskDomain task) async {
    final advanceId = Object.hash(task.id, Constants.advanceId);
    final exactId = Object.hash(task.id, Constants.exactId);

    await NotificationService.cancel(advanceId);
    await NotificationService.cancel(exactId);
  }
}
