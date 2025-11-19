import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository_impl.dart';
import 'package:flutter_app_todo/domain/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toggleMorningUseCaseProvider = Provider<ToggleMorningUseCase>(
  (ref) => ToggleMorningUseCase(ref.watch(notificationRepositoryProvider)),
);

class ToggleMorningUseCase extends UseCase<void, bool> {
  ToggleMorningUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(bool enabled) {
    return _repository.setMorningEnabled(enabled: enabled);
  }
}
