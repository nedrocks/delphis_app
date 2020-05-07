import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum GradientName {
  MOD_PURPLE,
  VERIFIED_TEAL,
  MAUVE,
  FUSCHIA,
  CINNABAR,
  VERMILLION,
  CERULEAN,
  TURQUOISE,
  CELADON,
  TAUPE,
  SAFFRON,
  VIRIDIAN,
  CHARTRUESE,
  LAVENDER,
  GOLDENROD,
  SEAFOAM,
  AZALEA,
  VIOLET,
  MAHOGANY,
}

GradientName gradientNameFromString(String stringName) {
  print('string name: $stringName');
  if (stringName == null) {
    return GradientName.MAUVE;
  }
  return GradientName.values.firstWhere(
      (element) =>
          element.toString().split('.')[1].toLowerCase() ==
          stringName.toLowerCase(), orElse: () {
    return GradientName.MAUVE;
  });
}

String gradientColorFromGradientName(GradientName gradientName) {
  return gradientName.toString().split('.')[1];
}

const List<GradientName> allChathamGradients = GradientName.values;
const GradientName moderatorGradientName = GradientName.MOD_PURPLE;
final List<GradientName> anonymousGradients = GradientName.values
    .where(
        (n) => n != GradientName.MOD_PURPLE && n != GradientName.VERIFIED_TEAL)
    .toList();

class UnitCircleLocations {
  static final TOP = getLocationForAngleInDegrees(90);
  static final TOP_LEFT = getLocationForAngleInDegrees(135);
  static final LEFT = getLocationForAngleInDegrees(180);
  static final BOTTOM_LEFT = getLocationForAngleInDegrees(225);
  static final BOTTOM = getLocationForAngleInDegrees(270);
  static final BOTTOM_RIGHT = getLocationForAngleInDegrees(315);
  static final RIGHT = getLocationForAngleInDegrees(0);
  static final TOP_RIGHT = getLocationForAngleInDegrees(45);

  static Alignment getLocationForAngleInDegrees(double angleInDegrees) {
    final radians = angleInDegrees * pi / 180.0;
    // NOTE: The alignment is reversed in the y direction.
    return Alignment(cos(radians), -1 * sin(radians));
  }
}

class GradientStop {
  final Color color;
  final double stopPct;

  const GradientStop(this.color, stopPct)
      : assert(stopPct >= 0 && stopPct <= 100),
        this.stopPct = stopPct;
}

class ChathamColors {
  static final signInTwitterBackground = Color.fromRGBO(57, 58, 63, 1.0);
  static final twitterLogoColor = Color.fromRGBO(102, 196, 254, 1.0);

  static final Map<GradientName, Gradient> gradients = {
    GradientName.MOD_PURPLE: LinearGradient(
        colors: [
          Color.fromRGBO(197, 76, 185, 1.0),
          Color.fromRGBO(80, 76, 197, 1.0),
          Color.fromRGBO(121, 76, 197, 1.0),
        ],
        begin: UnitCircleLocations.TOP_RIGHT,
        end: UnitCircleLocations.BOTTOM_LEFT,
        stops: [
          0.0,
          0.52,
          1.0,
        ]),
    GradientName.VERIFIED_TEAL: LinearGradient(
      colors: [
        Color.fromRGBO(85, 172, 238, 1.0),
        Color.fromRGBO(28, 203, 241, 1.0),
        Color.fromRGBO(28, 241, 102, 1.0),
      ],
      begin: UnitCircleLocations.TOP_RIGHT,
      end: UnitCircleLocations.BOTTOM_LEFT,
      stops: [
        0.0,
        0.52,
        1.0,
      ],
    ),
    GradientName.MAUVE: LinearGradient(
      colors: [
        Color.fromRGBO(251, 194, 235, 1.0),
        Color.fromRGBO(161, 140, 209, 1.0),
      ],
      begin: UnitCircleLocations.TOP,
      end: UnitCircleLocations.BOTTOM,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.FUSCHIA: LinearGradient(
      colors: [
        Color.fromRGBO(164, 69, 178, 1.0),
        Color.fromRGBO(212, 24, 114, 1.0),
        Color.fromRGBO(255, 0, 102, 1.0),
      ],
      begin: UnitCircleLocations.TOP_RIGHT,
      end: UnitCircleLocations.BOTTOM_LEFT,
      stops: [
        0.0,
        0.52,
        1.0,
      ],
    ),
    GradientName.CINNABAR: LinearGradient(
      colors: [
        Color.fromRGBO(177, 42, 91, 1.0),
        Color.fromRGBO(207, 85, 108, 1.0),
        Color.fromRGBO(255, 140, 127, 1.0),
        Color.fromRGBO(255, 129, 119, 1.0),
      ],
      begin: UnitCircleLocations.RIGHT,
      end: UnitCircleLocations.LEFT,
      stops: [
        0.0,
        0.25,
        0.63,
        1.0,
      ],
    ),
    GradientName.VERMILLION: LinearGradient(
      colors: [
        Color.fromRGBO(255, 177, 153, 1.0),
        Color.fromRGBO(255, 8, 68, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.CERULEAN: LinearGradient(
      colors: [
        Color.fromRGBO(120, 174, 255, 1.0),
        Color.fromRGBO(102, 196, 254, 1.0),
        Color.fromRGBO(33, 28, 241, 1.0),
      ],
      begin: Alignment(0.7071, -0.7071),
      end: Alignment(-0.7071, 0.7071),
      stops: [
        0.0,
        0.52,
        1.0,
      ],
    ),
    GradientName.TURQUOISE: LinearGradient(
      colors: [
        Color.fromRGBO(55, 236, 186, 1.0),
        Color.fromRGBO(114, 175, 211, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.CELADON: LinearGradient(
      colors: [
        Color.fromRGBO(150, 251, 196, 1.0),
        Color.fromRGBO(249, 245, 134, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.TAUPE: LinearGradient(
      colors: [
        Color.fromRGBO(223, 165, 121, 1.0),
        Color.fromRGBO(199, 144, 129, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.SAFFRON: LinearGradient(
      colors: [
        Color.fromRGBO(251, 171, 126, 1.0),
        Color.fromRGBO(247, 206, 104, 1.0),
      ],
      begin: UnitCircleLocations.getLocationForAngleInDegrees(332),
      end: UnitCircleLocations.getLocationForAngleInDegrees(152),
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.VIRIDIAN: LinearGradient(
      colors: [
        Color.fromRGBO(11, 163, 96, 1.0),
        Color.fromRGBO(60, 186, 146, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.CHARTRUESE: LinearGradient(
      colors: [
        Color.fromRGBO(249, 240, 71, 1.0),
        Color.fromRGBO(15, 216, 80, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.LAVENDER: LinearGradient(
      colors: [
        Color.fromRGBO(82, 113, 196, 1.0),
        Color.fromRGBO(177, 159, 255, 1.0),
        Color.fromRGBO(236, 161, 254, 1.0),
      ],
      begin: UnitCircleLocations.TOP_RIGHT,
      end: UnitCircleLocations.BOTTOM_LEFT,
      stops: [
        0.0,
        0.49,
        1.0,
      ],
    ),
    GradientName.GOLDENROD: LinearGradient(
      colors: [
        Color.fromRGBO(255, 78, 80, 1.0),
        Color.fromRGBO(249, 212, 35, 1.0),
      ],
      begin: UnitCircleLocations.LEFT,
      end: UnitCircleLocations.RIGHT,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.SEAFOAM: LinearGradient(
      colors: [
        Color.fromRGBO(208, 242, 231, 1.0),
        Color.fromRGBO(153, 244, 217, 1.0),
        Color.fromRGBO(101, 234, 176, 1.0),
      ],
      begin: UnitCircleLocations.LEFT,
      end: UnitCircleLocations.RIGHT,
      stops: [
        0.0,
        0.49,
        1.0,
      ],
    ),
    GradientName.AZALEA: LinearGradient(
      colors: [
        Color.fromRGBO(208, 150, 147, 1.0),
        Color.fromRGBO(199, 29, 111, 1.0),
      ],
      begin: UnitCircleLocations.BOTTOM,
      end: UnitCircleLocations.TOP,
      stops: [
        0.0,
        1.0,
      ],
    ),
    GradientName.VIOLET: LinearGradient(
      colors: [
        Color.fromRGBO(172, 50, 228, 1.0),
        Color.fromRGBO(121, 24, 242, 1.0),
        Color.fromRGBO(72, 1, 255, 1.0),
      ],
      begin: UnitCircleLocations.TOP_RIGHT,
      end: UnitCircleLocations.BOTTOM_LEFT,
      stops: [
        0.0,
        0.48,
        1.0,
      ],
    ),
    GradientName.MAHOGANY: LinearGradient(
      colors: [
        Color.fromRGBO(209, 84, 38, 1.0),
        Color.fromRGBO(182, 27, 88, 1.0),
      ],
      begin: UnitCircleLocations.RIGHT,
      end: UnitCircleLocations.LEFT,
      stops: [
        0.0,
        1.0,
      ],
    ),
  };
}
