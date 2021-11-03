import 'dart:convert';

import 'package:flutter/services.dart';

import 'order_model.dart';
import 'package:dartz/dartz.dart';

class GetDataFileAsList {
  Future<List> call() async {
    String jsonFile = await rootBundle.loadString('assets/data/orders.json');
    return await decodeJsonFile(jsonFile);
  }

  Future<List> decodeJsonFile(String jsonFile) async =>
      await json.decode(jsonFile);

  List<OrderModel> getOrderList(List data) =>
      data.map((e) => OrderModel.fromJson(e)).toList();
}

class OrdersReport {
  Either<Exception, int> getNumOfReturns(List<OrderModel> orders) {
    int numOfReturns = 0;
    try {
      for (var element in orders) {
        if (element.status == "RETURNED") {
          numOfReturns++;
        }
      }
      return Right(numOfReturns);
    } catch (e) {
      rethrow;
    }
  }

  getAveragePrice(List<OrderModel> orders) {
    double total = 0.0;
    for (var element in orders) {
      double price =
          double.parse(element.price!.substring(1).replaceFirst(",", ""));
      total = total + price;
    }
    return total / orders.length;
  }

  getMapOrdersBerMonth(List<OrderModel> orders) {
    List<int> months = [];
    Map<int, int> count = {};
    for (var element in orders) {
      months.add(DateTime.parse(element.registered!).month);
    }
    months.sort();
    for (var i in months) {
      count[i] = (count[i] ?? 0) + 1;
    }
    return count;
  }
}
