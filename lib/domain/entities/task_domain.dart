import 'package:equatable/equatable.dart';
import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';

class TaskDomain extends Equatable {
  const TaskDomain({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.time,
    required this.category,
    required this.isCompleted,
  });

  const TaskDomain.empty({
    this.id = '',
    this.title = '',
    this.description = '',
    this.date,
    this.time,
    this.category = TaskCategory.none,
    this.isCompleted = false,
  });

  bool get hasDate => date != null && date!.trim().isNotEmpty;
  bool get hasTime => time != null && time!.trim().isNotEmpty;
  bool get hasDateTime => hasDate && hasTime;

  final String id;
  final String title;
  final String description;
  final String? date;
  final String? time;
  final TaskCategory category;
  final bool isCompleted;

  TaskDomain copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    TaskCategory? category,
    bool? isCompleted,
  }) {
    return TaskDomain(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, date, time, category, isCompleted];
}
