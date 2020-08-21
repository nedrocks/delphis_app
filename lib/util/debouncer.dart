import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    /* Debouce any action after the first */
    if (_timer != null) {
      _timer.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    }
    /* Launch the very first action immediately */
    _timer = Timer(Duration.zero, action);
  }

  bool get isWaiting {
    return _timer?.isActive ?? false;
  }

  void cancel() {
    print("canceled");
    _timer?.cancel();
  }
}
