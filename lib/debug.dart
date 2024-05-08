import 'dart:developer' as developer;

class Debug {
  Debug._internal();

  factory Debug() => Debug._internal();

  static bool enabled = false;

  static void log(dynamic message) {
    if (enabled) {
      print('[DEBUG] $message');
    }
  }

  static void d(dynamic message, {String tag = 'DEBUG'}) {
    if (enabled) {
      developer.log(message.toString(), name: tag);
    }
  }
}
