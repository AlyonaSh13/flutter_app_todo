import 'package:drift/drift.dart';
import 'package:flutter_app_todo/data/database/table_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_todo/data/database/connection/connection.dart' as impl;
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase({required QueryExecutor e}) : super(e);

  AppDatabase.forTesting(DatabaseConnection super.connection);

  static final provider = Provider<AppDatabase>((ref) {
    final db = impl.constructDb();
    ref.onDispose(() => db.close());
    return db;
  });

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Future<Task?> getTaskById(String id) => (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<List<Task>> getTasksByDate(String date) async {
    return (select(tasks)..where((t) => t.date.equals(date))).get();
  }

  Future<Task> insertTask(TasksCompanion task) => into(tasks).insertReturning(task);
  Future<void> updateTaskById(TasksCompanion task) => update(tasks).replace(task);
  Future<void> deleteTaskById(String id) => (delete(tasks)..where((t) => t.id.equals(id))).go();

  @override
  int get schemaVersion => 1;
}
