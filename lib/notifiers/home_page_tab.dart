import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';

class HomePageTabNotifier extends ChangeNotifier {
  HomePageTab _current;

  HomePageTabNotifier(this._current);

  HomePageTab get value => _current;

  set value(HomePageTab value) {
    _current = value;
    notifyListeners();
  }
}
