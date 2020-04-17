import 'package:flutter/material.dart';

enum GradientName {
  MOD_PURPLE,
  VERIFIED_TEAL,
}

class GradientStop {
  final Color color;
  final double stopPct;

  const GradientStop(this.color, stopPct): 
    assert(stopPct >= 0 && stopPct <= 100),
    this.stopPct = stopPct;
}

class ChathamColors {
  static const Map<GradientName, Gradient> gradients = const {
    GradientName.MOD_PURPLE: LinearGradient(
      colors: [
        Color.fromRGBO(197, 76, 185, 1.0),
        Color.fromRGBO(80, 76, 197, 1.0),
        Color.fromRGBO(121, 76, 197, 1.0),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [
        0.0,
        0.52,
        1.0,
      ]
    ),
    GradientName.VERIFIED_TEAL: LinearGradient(
      colors: [
        Color.fromRGBO(85, 172, 238, 1.0),
        Color.fromRGBO(28, 203, 241, 1.0),
        Color.fromRGBO(28, 241, 102, 1.0),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      stops: [
        0.0,
        0.52,
        1.0,
      ],
    ),
  };
}