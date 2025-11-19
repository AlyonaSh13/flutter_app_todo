import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/task_repository_impl.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/domain/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTasksByDateUseCaseProvider = Provider<GetTasksByDateUseCase>(
  (ref) => GetTasksByDateUseCase(ref.watch(taskRepositoryProvider)),
);

class GetTasksByDateUseCase extends UseCase<List<TaskDomain>, String> {
  GetTasksByDateUseCase(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<TaskDomain>> call(String date) {
    return _repository.getTasksByDate(date: date);
  }
}
