import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository_impl.dart';
import 'package:flutter_app_todo/domain/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteTaskByIdUseCaseProvider = Provider<DeleteTaskByIdUseCase>(
  (ref) => DeleteTaskByIdUseCase(ref.watch(taskRepositoryProvider)),
);

class DeleteTaskByIdUseCase extends UseCase<void, String> {
  DeleteTaskByIdUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(String params) async {
    return await _repository.deleteTaskById(id: params);
  }
}
