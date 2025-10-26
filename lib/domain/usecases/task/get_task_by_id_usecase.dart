import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTaskByIdUseCaseProvider = Provider(
  (ref) => GetTaskByIdUseCase(ref.watch(taskRepositoryProvider)),
);

class GetTaskByIdUseCase {
  GetTaskByIdUseCase(this._repository);

  final TaskRepository _repository;

  Future<TaskDomain?> execute(String id) {
    return _repository.getTaskById(id: id);
  }
}
