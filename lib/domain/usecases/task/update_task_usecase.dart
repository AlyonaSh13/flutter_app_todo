import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateTaskUseCaseProvider = Provider((ref) => UpdateTaskUseCase(ref.watch(taskRepositoryProvider)));

class UpdateTaskUseCase extends UseCase<void, TaskDomain> {
  UpdateTaskUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(TaskDomain params) async {
    await _repository.updateTask(task: params);
  }
}
