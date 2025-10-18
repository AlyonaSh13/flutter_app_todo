import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteTaskUseCaseProvider = Provider(
  (ref) => DeleteTaskUseCase(ref.watch(taskRepositoryProvider)),
);

class DeleteTaskUseCase extends UseCase<void, String> {
  DeleteTaskUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(String params) async {
    return await _repository.deleteTask(id: params);
  }
}
