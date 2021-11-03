import 'package:flutter_test/flutter_test.dart';
import 'package:untitled2/models/data.dart';
import 'package:untitled2/models/order_model.dart';

main() {
  group('HomeScreen GetData', () {
    late GetDataFileAsList dataFile;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      dataFile = GetDataFileAsList();
    });

    test('should invoke asset json file and return a list', () async {
      List data = await dataFile();

      expect(data.isNotEmpty, true);
    });

    test('should invoke GetDataFileAsList and return an Order list', () async {
      List data = await dataFile();
      List<OrderModel> orders = dataFile.getOrderList(data);

      expect(orders.isNotEmpty, true);
    });

    test('should return int', () async {
      List data = await dataFile();
      List<OrderModel> orders = dataFile.getOrderList(data);
      OrdersReport ordersReport = OrdersReport();
      var numOfReturns = ordersReport.getNumOfReturns(orders);

      expect(numOfReturns.isRight(), true);
    });
  });
}
