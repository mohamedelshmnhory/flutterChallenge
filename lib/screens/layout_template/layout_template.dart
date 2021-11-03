import 'package:flutter/material.dart';

import 'package:untitled2/widgets/screen_info.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  const LayoutTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, sizingInformation) => Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
