import 'package:flutter/material.dart';
import 'package:untitled2/screens/layout_template/layout_template.dart';
import 'locator.dart';
import 'routing/route_names.dart';
import 'routing/router.dart';
import 'screens/home_screen.dart';
import 'services/navigation_service.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => LayoutTemplate(child: child!),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: HomeRoute,
    );
  }
}
