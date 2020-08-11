import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LAST_ROUTE_PREFERENCES_KEY = 'last_route';
const LAST_ROUTE_PREFERENCES_ARGUMENTS = 'last_route_arguments';
const LAST_ROUTE_PREFERENCES_ARGUMENTS_TYPE = 'last_route_arguments_type';

// Not sure if this is a good singleton pattern in dart. TODO Look this up.
final _ChathamRouteObserver chathamRouteObserverSingleton =
    _ChathamRouteObserver();

class _ChathamRouteObserver extends RouteObserver {
  bool hasLoadedApp = false;

  void saveLastRoute(Route lastRoute) async {
    final allowedRouteNames = ["/Discussion"];
    if (this.hasLoadedApp ||
        lastRoute == null ||
        lastRoute.settings == null ||
        lastRoute.settings.name == null ||
        !allowedRouteNames.contains(lastRoute.settings.name)) {
      // Don't save the intro or auth flow.
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LAST_ROUTE_PREFERENCES_KEY, lastRoute.settings.name);
    if (lastRoute.settings.arguments != null) {
      var encodedArgs;
      var argsType;
      switch (lastRoute.settings.arguments.runtimeType) {
        case DiscussionArguments:
          encodedArgs = (lastRoute.settings.arguments as DiscussionArguments)
              .toJsonString();
          argsType = 'DiscussionArguments';
          break;
        default:
          break;
      }
      if (argsType != null) {
        prefs.setString(LAST_ROUTE_PREFERENCES_ARGUMENTS, encodedArgs);
        prefs.setString(LAST_ROUTE_PREFERENCES_ARGUMENTS_TYPE, argsType);
      }
    }
  }

  Future<String> retrieveLastRouteName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LAST_ROUTE_PREFERENCES_KEY);
  }

  Future<Object> retriveLastRouteArguments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final args = prefs.getString(LAST_ROUTE_PREFERENCES_ARGUMENTS);
    final type = prefs.getString(LAST_ROUTE_PREFERENCES_ARGUMENTS_TYPE);
    switch (type) {
      case 'DiscussionArguments':
        return DiscussionArguments.fromJsonString(args);
      default:
        break;
    }
    return null;
  }

  @override
  void didPop(Route route, Route previousRoute) {
    saveLastRoute(previousRoute); // note : take route name in stacks below
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    saveLastRoute(route); // note : take new route name that just pushed
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    saveLastRoute(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    saveLastRoute(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
