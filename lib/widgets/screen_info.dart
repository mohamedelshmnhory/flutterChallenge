import 'package:flutter/material.dart';

import '../models/device_info.dart';

enum TheDeviceType { Mobile, Tablet, Desctop }

class InfoWidget extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;

  const InfoWidget({Key? key, required this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      var mediaQueryData = MediaQuery.of(context);
      var deviceInfo = DeviceInfo(
          orientation: mediaQueryData.orientation,
          deviceType: gteDeviceType(mediaQueryData),
          screenWidth: mediaQueryData.size.width,
          screenHeight: mediaQueryData.size.height,
          localHeight: constrains.maxHeight,
          localWidth: constrains.maxWidth);
      return builder(context, deviceInfo);
    });
  }
}

TheDeviceType gteDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double width = 0;
  if (orientation == Orientation.landscape) {
    width = mediaQueryData.size.height;
  } else {
    width = mediaQueryData.size.width;
  }
  if (width >= 950) {
    return TheDeviceType.Desctop;
  }
  if (width >= 600) {
    return TheDeviceType.Tablet;
  }
  return TheDeviceType.Mobile;
}
