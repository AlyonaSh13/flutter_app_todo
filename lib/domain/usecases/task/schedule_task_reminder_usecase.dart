import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleTaskReminderUseCaseProvider = Provider(
  (ref) => ScheduleTaskReminderUseCase(ref.watch(notificationRepositoryProvider)),
);

class ScheduleTaskReminderUseCase extends UseCase<void, TaskDomain> {
  ScheduleTaskReminderUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(TaskDomain params) {
    return _repository.scheduleTaskReminder(task: params);
  }
}
