import 'package:logger/logger.dart';

class LoggerUtils {
  static Logger logger = Logger();

  static void d(String msg) {
    logger.d(msg);
  }

  static void e(String msg) {
    logger.e(msg);
  }
}
