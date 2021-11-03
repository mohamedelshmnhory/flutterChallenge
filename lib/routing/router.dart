import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/screens/chart_screen.dart';
import 'package:untitled2/screens/home_screen.dart';

import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(const MyHomePage(title: 'Reports'), settings);
    case ChartRoute:
      Map<int, int> count = settings.arguments as Map<int, int>;
      return _getPageRoute(Chart(count: count), settings);
    default:
      return _getPageRoute(const MyHomePage(title: 'title'), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
