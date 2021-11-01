import 'package:flutter/material.dart';

import '../widgets/screen_info.dart';

class DeviceInfo {
  final Orientation? orientation;
  final TheDeviceType? deviceType;
  final double? screenWidth;
  final double? screenHeight;
  final double? localWidth;
  final double? localHeight;

  DeviceInfo(
      {this.orientation,
        this.deviceType,
        this.screenWidth,
        this.screenHeight,
        this.localWidth,
        this.localHeight});
}