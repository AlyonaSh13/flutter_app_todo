import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository_impl.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) => GetTasksUseCase(ref.watch(taskRepositoryProvider)));

class GetTasksUseCase extends ExecuteUseCase<List<TaskDomain>> {
  GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<TaskDomain>> execute() {
    return _repository.getTasks();
  }
}
