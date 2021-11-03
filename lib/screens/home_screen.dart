import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/models/device_info.dart';
import 'package:untitled2/models/order_model.dart';
import 'package:untitled2/widgets/screen_info.dart';

import 'chart_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    }
    months.sort();
    for (var i in months) {
      count[i] = (count[i] ?? 0) + 1;
    }
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(builder: (BuildContext context, DeviceInfo deviceInfo) {
      bool isMobile = deviceInfo.deviceType == TheDeviceType.Mobile;
      return Scaffold(
        appBar: isMobile
            ? AppBar(title: Text(widget.title), centerTitle: true)
            : null,
        body: Center(
          child: Row(
            children: [
              if (!isMobile) const Expanded(child: SizedBox()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Details(
                          orders: orders,
                          averagePrice: averagePrice,
                          numOfReturns: numOfReturns),
                      const SizedBox(height: 30),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Chart(count: count)));
                        },
                        child: const Text('Chart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isMobile) const Expanded(child: SizedBox()),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.3),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          DetailsLine(title: 'total count:', text: '${orders.length} orders'),
          DetailsLine(
              title: 'average price:',
              text: '${averagePrice.toStringAsFixed(2)} \$'),
          DetailsLine(
              title: 'number of returns:', text: '$numOfReturns orders'),
        ],
      ),
    );
  }
}

class DetailsLine extends StatelessWidget {
  const DetailsLine({
    Key? key,
    required this.text,
    required this.title,
  }) : super(key: key);
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
