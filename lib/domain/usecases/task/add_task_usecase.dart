import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addTaskUseCaseProvider = Provider((ref) => AddTaskUseCase(ref.watch(taskRepositoryProvider)));

class AddTaskUseCase extends UseCase<String, TaskDomain> {
  AddTaskUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<String> call(TaskDomain params) async {
    return await _repository.addTask(task: params);
  }
}
