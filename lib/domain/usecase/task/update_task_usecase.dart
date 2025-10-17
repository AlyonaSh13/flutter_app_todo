import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateTaskUseCaseProvider = Provider(
  (ref) => UpdateTaskUseCase(ref.watch(taskRepositoryProvider)),
);

class UpdateTaskUseCase extends UseCase<void, UpdateTaskParams> {
  UpdateTaskUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(UpdateTaskParams params) async {
    return await _repository.updateTask(index: params.index, task: params.task);
  }
}

class UpdateTaskParams {
  const UpdateTaskParams({required this.index, required this.task});

  final int index;
  final TaskDomain task;
}
