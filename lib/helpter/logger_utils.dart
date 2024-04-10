import 'package:logger/logger.dart';

class LoggerUtils {
  static Logger logger = Logger();

  static void d(
      String msg, {
        Object? error,
      }) {
    logger.d(msg, error: error);
  }

  static void e(
      String msg, {
        Object? error,
      }) {
    logger.e(msg, error: error);
  }
}
