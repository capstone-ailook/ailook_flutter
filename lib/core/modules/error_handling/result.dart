abstract class Result<T> {
  static Result<T> failure<T>(Exception error) => Failure<T>(error);

  static Result<T> success<T>(T value) => Success<T>(value);

  T getOrThrow() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    } else {
      throw (this as Failure<T>).error;
    }
  }

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception e) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as Failure<T>).error);
    }
  }
}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Failure<T> extends Result<T> {
  final Exception error;

  Failure(this.error);
}