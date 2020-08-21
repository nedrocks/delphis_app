import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  bool get isWaiting {
    return _timer?.isActive ?? false;
  }
}
