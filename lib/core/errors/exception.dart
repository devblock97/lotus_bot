/// Base exception for data sources and infrastructure layers.
abstract class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when local database operations fail.
class LocalDatabaseException extends AppException {
  const LocalDatabaseException(super.message, [super.cause]);
}

/// Thrown when network connectivity or HTTP requests fail.
class NetworkException extends AppException {
  const NetworkException(String message, {this.statusCode, Object? cause})
      : super(message, cause);

  final int? statusCode;
}

/// Thrown when an AI provider returns an error or invalid payload.
class AiProviderException extends AppException {
  const AiProviderException(super.message, [super.cause]);
}
