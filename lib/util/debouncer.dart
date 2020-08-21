import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    /* First action is not debounced */
    if (_timer == null) {
      _timer = Timer(Duration.zero, action);
      return;
    }
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  bool get isWaiting {
    return _timer?.isActive ?? false;
  }

  void cancel() {
    _timer?.cancel();
  }
}
