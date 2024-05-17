import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_a_z/db/db_helper.dart';

import '../models/order_model.dart';
import '../models/telescope_model.dart';

class OrderProvider with ChangeNotifier{
  List<OrderModel>  orderList = [];
  final random = Random.secure();

  int get getColorCode => (255 * random.nextDouble()).toInt();

  getAllOrders() {
    DbHelper.getAllOrders().listen((event) {
      orderList = List.generate(event.docs.length,
              (index) => OrderModel.fromJson(event.docs[index].data()));
      notifyListeners();
    });
  }

  OrderModel getOrderById(String id) =>
      orderList.firstWhere((element) => element.orderId == id);

  Future<List<Map<String, dynamic>>> preparePieChartDataForBrand(List<TelescopeModel> telescopeList) async {
    List<Map<String, dynamic>> brandQuantityPercentMapList = [];
    Map<String, num> brandQuantityMap = await _getBrandQuantityMap(telescopeList);
    num totalQuantity = 0;
    for(final order in orderList) {
      for (final cart in order.itemDetails) {
        totalQuantity += cart.quantity;
      }
    }

    for(var key in brandQuantityMap.keys) {
      final map = <String, dynamic> {};
      map['brand'] = key;
      map['qty'] = brandQuantityMap[key];
      map['percent'] = (brandQuantityMap[key]! * 100) / totalQuantity;
      map['color'] = Color.fromARGB(255, getColorCode, getColorCode, getColorCode);
      brandQuantityPercentMapList.add(map);
    }
    return brandQuantityPercentMapList;
  }

  Future<Map<String, num>> _getBrandQuantityMap(List<TelescopeModel> telescopeList) async {
    Map<String, num> brandQuantityMap = {};
    for(final order in orderList) {
      for(final cart in order.itemDetails) {
        final telescope = telescopeList.firstWhere((telescope) => telescope.id == cart.telescopeId);
        final brandName = telescope.brand.name;
        num prevQuantity = brandQuantityMap[brandName] ?? 0;
        brandQuantityMap[brandName] = prevQuantity + cart.quantity;
      }
    }
    return brandQuantityMap;
  }

  Future<Map<num, double>> prepareLineChartForYearlySale(num year) async {
    Map<num, double> monthlySaleMap = {};
    final yearlyOrderList = orderList.where((order) => order.orderDate.toDate().year == year).toList();
    for(final order in yearlyOrderList) {
      double prevAmount = monthlySaleMap[order.orderDate.toDate().month] ?? 0.0;
      monthlySaleMap[order.orderDate.toDate().month] = prevAmount + order.totalAmount.toDouble();
    }
    return monthlySaleMap;
  }

  List<FlSpot> generateSpots(Map<num, double> map) {
    List<FlSpot> spots = [];
    for(final key in map.keys) {
      final flSpot = FlSpot(key.toDouble(), map[key]!);
      spots.add(flSpot);
    }
    return spots;
  }

  double findMaxY(Map<num, double> map) {
    double max = 0.0;
    List<double> totalSales = map.values.toList();
    if(totalSales.isEmpty) {
      return 0.0;
    }
    totalSales.sort((a, b) => a.compareTo(b));
    return totalSales.last + 500;
  }
}