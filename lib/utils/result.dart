/*
Uma sealed class é uma classe cuja árvore de subclasses é fechada.
Isso significa:
  * Somente classes declaradas no mesmo arquivo podem estendê-la ou implementá-la.
  *Fora desse arquivo, você não pode criar novos tipos derivados dela.
  *Permite ao compilador garantir que todos os casos possíveis são conhecidos.
*/
sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Error<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Error(this.error, [this.stackTrace]);
}


/*
// A sealed result type: represents either success (Ok) or failure (Error).
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;
  bool get isError => this is Error<T>;

  /// Extracts the value or returns `fallback`.
  T unwrapOr(T fallback) => switch (this) {
    Ok(value: final v) => v,
    Error() => fallback,
  };

  /// Extracts the value or throws the stored error.
  T getOrThrow() => switch (this) {
    Ok(value: final v) => v,
    Error(error: final e, stackTrace: final st) =>
        Error.throwWith(e, st),
  };

  /// Transforms the value if Result<T> is Ok.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok(value: final v) => Ok(transform(v)),
    Error(error: final e, stackTrace: final st) => Error(e, st),
  };
}

/// Represents a successful operation.
final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;

  @override
  String toString() => 'Ok($value)';
}

/// Represents an error result.
final class Error<T> extends Result<T> {
  const Error(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Error($error)';

  /// Helper to rethrow error with its original stack trace.
  static Never throwWith(Object e, StackTrace? st) {
    if (st != null) {
      Error.throwWithStacktrace(e, st);
    }
    throw e;
  }

  static Never throwWithStacktrace(Object e, StackTrace st) {
    // ignore: only_throw_errors
    throw Error.throwWithStacktraceImpl(e, st);
  }

  static Never throwWithStacktraceImpl(Object e, StackTrace st) {
    Error.throwWithNested(e, st);
  }

  static Never throwWithNested(Object e, StackTrace st) {
    // ignore: only_throw_errors
    throw Error.throwWithNestedImpl(e, st);
  }

  static Never throwWithNestedImpl(Object e, StackTrace st) {
    // ignore: only_throw_errors
    throw e;
  }
}
 */
