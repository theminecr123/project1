  import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class OrderController extends GetxController {
  final box = GetStorage();
    Logger logger = new Logger();

  void saveOrder(Map<String, dynamic> orderData) {
    logger.i(orderData);
    
    var orders = box.read('pendingOrder');
    if (orders is! List) {
      orders = []; 
    }

    // Add new order
    orders.add({
      'orderId': DateTime.now().millisecondsSinceEpoch, 
      'date': DateTime.now().toString(),
      'orderData': orderData,
    });

    // Write back to GetStorage
    box.write('pendingOrder', orders);
  }
}
