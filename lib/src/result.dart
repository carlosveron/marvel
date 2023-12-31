class Result<T> extends _$Result<T> {
  Result._();
  factory Result.data(T value) = _ResultData<T>;
  factory Result.error(Object error, [StackTrace? stackTrace]) = _ResultErro<T>;

  factory Result.guard(T Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  static Future<Result<T>> guardFuture<T>(Future<T> Function() cb) async {
    try {
      return Result.data(await cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  Result<Res> chain<Res>(Res Function(T value) cb) {
    return when(
      data: (value) {
        try {
          return Result.data(cb(value));
        } catch (err, stack) {
          return Result.error(err, stack);
        }
      },
      error: Result.error,
    );
  }

  T get dataOrThrow {
    return when(
      data: (value) => value,
      error: (err, stack) {
        throw err;
      },
    );
  }
}
