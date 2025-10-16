import 'package:flutter_app_todo/core/utils/get_task_category_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_entity.g.dart';

@JsonSerializable()
class TaskEntity {
  TaskEntity({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    this.isCompleted = false,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  final String title;
  final String description;
  final String date;
  final String time;
  final TaskCategory category;
  final bool isCompleted;

  Map<String, dynamic> toJson() => _$TaskEntityToJson(this);
}
