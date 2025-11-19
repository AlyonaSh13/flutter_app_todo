import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository_impl.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTaskByIdUseCaseProvider = Provider<GetTaskByIdUseCase>(
  (ref) => GetTaskByIdUseCase(ref.watch(taskRepositoryProvider)),
);

class GetTaskByIdUseCase extends UseCase<TaskDomain?, String> {
  GetTaskByIdUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<TaskDomain?> call(String id) {
    return _repository.getTaskById(id: id);
  }
}
