import 'package:flutter/foundation.dart';

/// Base Failure class for domain error handling.
@immutable
abstract class Failure {
  const Failure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause;

  @override
  int get hashCode => message.hashCode ^ cause.hashCode;

  @override
  String toString() => '$runtimeType: $message';
}

/// Network connectivity or protocol failure.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.cause]);
}

/// Operation timeout failure.
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, [super.cause]);
}

/// Remote API error responses.
class ApiFailure extends Failure {
  const ApiFailure(String message, {this.statusCode, Object? cause})
      : super(message, cause);

  final int? statusCode;
}

/// Local SQLite / Drift database failure.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.cause]);
}

/// AI Provider execution or response streaming failure.
class AiProviderFailure extends Failure {
  const AiProviderFailure(super.message, [super.cause]);
}

/// Unexpected or unhandled errors.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.cause]);
}
