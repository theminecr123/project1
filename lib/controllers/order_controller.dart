  import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:uuid/uuid.dart';

class OrderController extends GetxController {
  final orders = <Map<String, dynamic>>[].obs;
  final Uuid uuid = Uuid();
  Logger logger = new Logger();
  GetStorage box =  GetStorage();
  void saveOrder(Map<String, dynamic> cartData) {
    List<dynamic> existingOrders = List<Map<String, dynamic>>.from(box.read('pendingOrder') ?? []);

    logger.i(existingOrders);
    final orderId = uuid.v4();  // Generate unique ID
    final int productCount = cartData['products'].length;
    final double orderTotal = cartData['products'].fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );

    final order = {
      'id': orderId,
      'products': cartData['products'],
      'total': orderTotal,
      'productCount': productCount,
      'date': DateTime.now().toIso8601String(),
    };
    existingOrders.add(order);

    box.write('pendingOrder', existingOrders);
    box.remove('cartData');
    
  }
}
