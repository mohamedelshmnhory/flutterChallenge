import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled2/models/device_info.dart';
import 'package:untitled2/widgets/app_bar.dart';
import 'package:untitled2/widgets/screen_info.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.count,
  }) : super(key: key);
  final Map<int, int> count;

  @override
  Widget build(BuildContext context) {
    return InfoWidget(builder: (BuildContext context, DeviceInfo deviceInfo) {
      bool isMobile = deviceInfo.deviceType == TheDeviceType.Mobile;
      return Column(
        children: [
          if (isMobile) const CustomAppBar(title: 'Chart', back: true),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 100.0 : 200,
                  horizontal: isMobile ? 20.0 : 50),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'the number of orders and time'),
                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                        dataSource: count.entries
                            .map((entry) => SalesData(
                                DateFormat('MMMM')
                                    .format(DateTime(0, entry.key))
                                    .substring(0, 3),
                                entry.value))
                            .toList(),
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]),
            ),
          ),
        ],
      );
    });
  }
}



class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final int sales;
}
