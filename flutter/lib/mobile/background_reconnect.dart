import 'package:flutter/widgets.dart';

class AndroidBackgroundReconnect {
  bool _backgrounded = false;
  bool _pending = false;

  bool deferConnectionError() {
    if (!_backgrounded) return false;
    _pending = true;
    return true;
  }

  bool updateLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgrounded = true;
    } else if (state == AppLifecycleState.resumed) {
      _backgrounded = false;
      final reconnect = _pending;
      _pending = false;
      return reconnect;
    }
    return false;
  }

  void clear() {
    _backgrounded = false;
    _pending = false;
  }
}
