import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setEnabledTimeUseCaseProvider = Provider(
  (ref) => SetEnabledTimeUseCase(ref.watch(notificationRepositoryProvider)),
);

class SetEnabledTimeUseCase extends UseCase<void, int> {
  SetEnabledTimeUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(int minute) {
    return _repository.setEnabledMinute(minute: minute);
  }
}
