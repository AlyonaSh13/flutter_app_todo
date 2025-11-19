import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toggleEveningUseCaseProvider = Provider((ref) => ToggleEveningUseCase(ref.watch(notificationRepositoryProvider)));

class ToggleEveningUseCase extends UseCase<void, bool> {
  ToggleEveningUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(bool enabled) {
    return _repository.setEveningEnabled(enabled: enabled);
  }
}
