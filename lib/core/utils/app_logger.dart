import 'package:logger/logger.dart';

/// Application-wide logger. Use instead of `print()`.
///
/// Usage:
/// ```dart
/// appLogger.i('Service loaded');
/// appLogger.e('Failed to fetch', error: e, stackTrace: st);
/// ```
final AppLogger appLogger = AppLogger._();

/// Wrapper around [Logger] providing named log levels.
class AppLogger {
  AppLogger._();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 6,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Debug message.
  void d(dynamic message) => _logger.d(message);

  /// Info message.
  void i(dynamic message) => _logger.i(message);

  /// Warning message.
  void w(dynamic message) => _logger.w(message);

  /// Error with optional [error] object and [stackTrace].
  void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
