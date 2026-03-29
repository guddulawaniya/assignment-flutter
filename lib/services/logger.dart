import 'package:flutter/foundation.dart';

/// Logger service — equivalent to React Native Logger.ts
/// In release builds, logging is suppressed.
class Logger {
  static void info(String message, [dynamic args]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[INFO] $message${args != null ? ' $args' : ''}');
    }
  }

  static void warn(String message, [dynamic args]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[WARN] $message${args != null ? ' $args' : ''}');
    }
  }

  static void error(String message, [dynamic args]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ERROR] $message${args != null ? ' $args' : ''}');
    }
  }
}
