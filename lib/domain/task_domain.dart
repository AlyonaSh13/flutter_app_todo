import 'package:equatable/equatable.dart';
import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/core/utils/get_task_category_color.dart';

class TaskDomain extends Equatable {
  const TaskDomain({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.isCompleted,
  });

  const TaskDomain.empty({
    this.title = '',
    this.description = '',
    this.date = DateFormats.dayMonthYear,
    this.time = DateFormats.hourMinute,
    this.category = TaskCategory.none,
    this.isCompleted = false,
  });

  final String title;
  final String description;
  final String date;
  final String time;
  final TaskCategory category;
  final bool isCompleted;

  TaskDomain copyWith({
    String? title,
    String? description,
    String? date,
    String? time,
    TaskCategory? category,
    bool? isCompleted,
  }) {
    return TaskDomain(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [
    title,
    description,
    date,
    time,
    category,
    isCompleted,
  ];
}
