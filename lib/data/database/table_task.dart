import 'package:drift/drift.dart';
import 'package:flutter_app_todo/data/database/database.dart';
import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:uuid/uuid.dart';

class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get date => text().nullable()();
  TextColumn get time => text().nullable()();
  TextColumn get category => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

extension TasksExtension on Task {
  TaskDomain toDomain() => TaskDomain(
    id: id,
    title: title,
    description: description ?? '',
    category: TaskCategory.values.firstWhere(
      (e) => e.name.trim().toLowerCase() == category?.trim().toLowerCase(),
      orElse: () => TaskCategory.none,
    ),
    date: date,
    time: time,
    isCompleted: isCompleted,
  );
}
