import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTaskUseCaseProvider = Provider(
  (ref) => GetTaskUseCase(ref.watch(taskRepositoryProvider)),
);

class GetTaskUseCase extends ExecuteUseCase<List<TaskDomain>> {
  GetTaskUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<TaskDomain>> execute() {
    return _repository.getTasks();
  }
}
