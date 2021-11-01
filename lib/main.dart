import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled2/models/order_model.dart';

import 'models/device_info.dart';
import 'widgets/screen_info.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TooltipBehavior _tooltipBehavior;
  List<OrderModel> orders = [];
  int numOfReturns = 0;
  double averagePrice = 0;
  List<int> months = [];
  Map<int, int> count = {};

  Future<String> getDataFile() async {
    return await rootBundle.loadString('assets/data/orders.json');
  }

  getData() async {
    String text = await getDataFile();
    List data = json.decode(text);
    orders = data.map((e) => OrderModel.fromJson(e)).toList();
    getNumOfReturns();
    getAveragePrice();
    getMonths();
    setState(() {});
  }

  getNumOfReturns() {
    for (var element in orders) {
      if (element.status == "RETURNED") {
        numOfReturns++;
      }
    }
  }

  getAveragePrice() {
    double total = 0;
    for (var element in orders) {
      double price =
          double.parse(element.price!.substring(1).replaceFirst(",", ""));
      total = total + price;
    }
    averagePrice = total / orders.length;
  }

  getMonths() {
    for (var element in orders) {
      months.add(DateTime.parse(element.registered!).month);
      // print(DateFormat.MMMM().format(DateTime.parse(element.registered!).month));
    }
    months.sort();
    for (var i in months) {
      count[i] = (count[i] ?? 0) + 1;
    }
  }

  @override
  initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InfoWidget(
            builder: (BuildContext context, DeviceInfo deviceInfo) {
              if (deviceInfo.deviceType == TheDeviceType.Mobile) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Details(
                        orders: orders,
                        averagePrice: averagePrice,
                        numOfReturns: numOfReturns),
                    const SizedBox(height: 30),
                    Chart(count: count),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Details(
                        orders: orders,
                        averagePrice: averagePrice,
                        numOfReturns: numOfReturns),
                    const SizedBox(height: 30),
                    Chart(count: count),
                  ],
                );
              }
            },
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.count,
  }) : super(key: key);

  final Map<int, int> count;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: ''),
        // Enable legend
        // legend: Legend(isVisible: true),
        // // Enable tooltip
        // tooltipBehavior: _tooltipBehavior,
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
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }
}

class Details extends StatelessWidget {
  const Details({
    Key? key,
    required this.orders,
    required this.averagePrice,
    required this.numOfReturns,
  }) : super(key: key);

  final List<OrderModel> orders;
  final double averagePrice;
  final int numOfReturns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('total count: ${orders.length} orders'),
        Text('average price: ${averagePrice.toStringAsFixed(2)} \$'),
        Text('number of returns: $numOfReturns orders'),
      ],
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final int sales;
}
