import 'dart:developer';

import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restoreDailyNotificationsUseCaseProvider = Provider<RestoreDailyNotificationsUseCase>((ref) {
  return RestoreDailyNotificationsUseCase(ref.read(notificationStartupRepositoryProvider));
});

class RestoreDailyNotificationsUseCase extends ExecuteUseCase<void> {
  RestoreDailyNotificationsUseCase(this._repository);

  final NotificationStartupRepository _repository;

  @override
  Future<void> execute() async {
    try {
      await Future.wait([_repository.restoreMorningNotification(), _repository.restoreEveningNotification()]);
    } catch (e, s) {
      log('Failed to restore daily notifications: $e\n$s');
    }
  }
}
