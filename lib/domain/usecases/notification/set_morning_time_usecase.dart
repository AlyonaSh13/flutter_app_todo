import 'package:flutter_app_todo/core/usecase/usecase.dart';
import 'package:flutter_app_todo/data/repository/notification_repository_impl.dart';
import 'package:flutter_app_todo/domain/repository/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setMorningTimeUseCaseProvider = Provider<SetMorningTimeUseCase>(
  (ref) => SetMorningTimeUseCase(ref.watch(notificationRepositoryProvider)),
);

class SetMorningTimeUseCase extends UseCase<void, SetMorningTimeParams> {
  SetMorningTimeUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<void> call(SetMorningTimeParams params) {
    return _repository.setMorningTime(hour: params.hour, minute: params.minute);
  }
}

class SetMorningTimeParams {
  const SetMorningTimeParams({required this.hour, required this.minute});

  final int hour;
  final int minute;
}
