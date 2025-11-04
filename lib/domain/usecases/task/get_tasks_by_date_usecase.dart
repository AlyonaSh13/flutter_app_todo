import 'package:flutter_app_todo/data/repository/task_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTasksByDateUseCaseProvider = Provider(
  (ref) => GetTasksByDateUseCase(ref.watch(taskRepositoryProvider)),
);

class GetTasksByDateUseCase {
  GetTasksByDateUseCase(this._repository);
  final TaskRepository _repository;

  Future<List<TaskDomain>> execute(String date) {
    return _repository.getTasksByDate(date: date);
  }
}
