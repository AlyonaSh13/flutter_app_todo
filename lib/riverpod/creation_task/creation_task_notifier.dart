import 'package:flutter_app_todo/domain/task_domain.dart';
import 'package:flutter_app_todo/domain/usecase/task/add_task_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'creation_task_notifier.g.dart';

class CreationTaskState {
  const CreationTaskState({required this.task, required this.isSuccess});

  const CreationTaskState.initial({
    this.isSuccess = false,
    this.task = const TaskDomain.empty(),
  });

  final TaskDomain task;
  final bool isSuccess;

  CreationTaskState copyWith({TaskDomain? task, bool? isSuccess}) {
    return CreationTaskState(
      task: task ?? this.task,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

@riverpod
class CreationTaskVm extends _$CreationTaskVm {
  @override
  CreationTaskState build() {
    return const CreationTaskState.initial();
  }

  Future<void> add(TaskDomain task) async {
    await ref.read(addTaskUseCaseProvider).call(task);
    state = state.copyWith(isSuccess: true);
  }

  void updateTask(TaskDomain task) {
    state = state.copyWith(task: task);
  }
}
