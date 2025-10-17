import 'package:equatable/equatable.dart';
import 'package:flutter_app_todo/domain/task_domain.dart';

class TaskWithIndexDomain extends Equatable {
  const TaskWithIndexDomain(this.task, this.index);

  final TaskDomain task;
  final int index;

  @override
  List<Object> get props => [task, index];
}
