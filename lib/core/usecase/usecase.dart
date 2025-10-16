abstract class UseCase<T, P> {
  Future<T> call(P params);
}

abstract class ExecuteUseCase<T> {
  Future<T> execute();
}
