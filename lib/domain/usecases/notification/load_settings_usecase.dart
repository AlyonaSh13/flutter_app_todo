import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_app_todo/domain/entities/notification_settings_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadNotificationSettingsUseCaseProvider = Provider(
  (ref) => LoadNotificationSettingsUseCase(ref.watch(notificationRepositoryProvider)),
);

class LoadNotificationSettingsUseCase extends ExecuteUseCase<NotificationSettingsDomain> {
  LoadNotificationSettingsUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<NotificationSettingsDomain> execute() {
    return _repository.loadSettings();
  }
}
