import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository_impl.dart';
import 'package:flutter_app_todo/domain/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setEveningTimeUseCaseProvider = Provider<SetEveningTimeUseCase>(
  (ref) => SetEveningTimeUseCase(ref.watch(notificationRepositoryProvider)),
);

class SetEveningTimeUseCase extends UseCase<void, SetEveningTimeParams> {
  SetEveningTimeUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(SetEveningTimeParams params) {
    return _repository.setEveningTime(hour: params.hour, minute: params.minute);
  }
}

class SetEveningTimeParams {
  const SetEveningTimeParams({required this.hour, required this.minute});

  final int hour;
  final int minute;
}
