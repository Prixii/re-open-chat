import 'dart:async';

import 'package:re_open_chat/utils/client_utils.dart';

class Polling {
  Polling({this.pollingTime = const Duration(seconds: 5)}) {
    timer = Timer(pollingTime, () {});
    timer.cancel();
  }

  final Duration pollingTime;
  late Timer timer;
  bool running = false;
  bool printDebug = false;

  /// 轮询
  void _run() async {
    running = true;
    await saveSnapShot();
    await sendRequest();
    await store();
    await notifyBloc().then(
      (_) {
        running = false;
        checkPageState();
      },
    );
  }

  void runAndRequestImmediately() {
    _run();
  }

  void runWithoutRequestImmediately() {
    checkPageState();
  }

  void checkPageState() {
    if (shouldRestartTimer()) {
      if (running == false) _startTimer();
    } else {
      if (running == true) timer.cancel();
      running = false;
    }
  }

  void stop() {
    if (running == true) timer.cancel();
    running = false;
  }

  Future<void> saveSnapShot() async {
    return;
  }

  Future<void> sendRequest() async {
    if (printDebug) talker.debug('sendRequest');
  }

  Future<void> store() async {
    if (printDebug) talker.debug('store');
  }

  Future<void> notifyBloc() async {
    if (printDebug) talker.debug('notifyBloc');
  }

  bool shouldRestartTimer() {
    if (printDebug) talker.debug('checkState');
    return true;
  }

  void _startTimer() {
    if (running) return;
    timer = Timer(pollingTime, () {
      _run();
    });
  }
}
