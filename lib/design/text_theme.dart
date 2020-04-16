import 'package:flutter/material.dart';

final kThemeData = ThemeData(
  brightness: Brightness.dark,

  primaryColor: Colors.black,
  accentColor: Colors.white,

  fontFamily: 'NeueHansKendrick',

  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(255, 255, 255, 0.92), letterSpacing: 0.14, height: 1.0),
    headline2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Color.fromRGBO(255, 255, 255, 0.8), letterSpacing: -0.22, height: 1.0),
    // It's strange to have a headline3 smaller than the body text. Not sure if there's a better way to lay this out?
    headline3: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(255, 255, 255, 0.48), letterSpacing: -0.19, height: 1.0),
    bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400, color: Color.fromRGBO(255, 255, 255, 0.92), letterSpacing: -0.39, height: 1.0),
    bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Color.fromRGBO(255, 255, 255, 0.8), textBaseline: TextBaseline.alphabetic, decoration: TextDecoration.none, height: 1.0),
  ),
);