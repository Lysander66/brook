import 'package:logger/logger.dart' as logger;

class Logger {
  final logger.Logger _logger = logger.Logger(
    printer: logger.PrefixPrinter(logger.PrettyPrinter(
      stackTraceBeginIndex: 5,
      methodCount: 1,
    )),
    level: logger.Level.info,
  );

  void v(dynamic message) {
    _logger.v(message);
  }

  void d(dynamic message) {
    _logger.d(message);
  }

  void i(dynamic message) {
    _logger.i(message);
  }

  void w(dynamic message) {
    _logger.w(message);
  }

  void e(dynamic message) {
    _logger.e(message);
  }

  void wtf(dynamic message) {
    _logger.wtf(message);
  }
}
