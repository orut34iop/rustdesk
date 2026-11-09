import 'package:flutter/widgets.dart';
import 'package:flutter_hbb/mobile/background_reconnect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('background errors request only one reconnect on resume', () {
    final recovery = AndroidBackgroundReconnect();
    recovery.updateLifecycle(AppLifecycleState.hidden);
    recovery.updateLifecycle(AppLifecycleState.paused);
    expect(recovery.deferConnectionError(), isTrue);
    expect(recovery.deferConnectionError(), isTrue);
    expect(recovery.updateLifecycle(AppLifecycleState.resumed), isTrue);
    expect(recovery.updateLifecycle(AppLifecycleState.resumed), isFalse);
  });

  test('healthy background sessions and foreground errors do not reconnect',
      () {
    final recovery = AndroidBackgroundReconnect();
    expect(recovery.deferConnectionError(), isFalse);
    recovery.updateLifecycle(AppLifecycleState.inactive);
    expect(recovery.deferConnectionError(), isFalse);
    recovery.updateLifecycle(AppLifecycleState.paused);
    expect(recovery.updateLifecycle(AppLifecycleState.resumed), isFalse);
    expect(recovery.deferConnectionError(), isFalse);
  });

  test('closing a session clears deferred recovery', () {
    final recovery = AndroidBackgroundReconnect();
    recovery.updateLifecycle(AppLifecycleState.paused);
    recovery.deferConnectionError();
    recovery.clear();
    expect(recovery.updateLifecycle(AppLifecycleState.resumed), isFalse);
  });
}
