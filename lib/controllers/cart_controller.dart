import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CartController extends GetxController {
  final box = GetStorage();
  var cartData = {}.obs;  // Local cart data
  var isLoading = true.obs;
  final Logger logger = Logger();
  var totalProductCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart(); // Load cart data from local storage on initialization
  }

  // Load cart from GetStorage
  void loadCart() {
    var storedCartData = box.read('cartData');
    if (storedCartData != null) {
      cartData.value = storedCartData;
      totalProductCount.value = getTotalProductCount();
    }
    isLoading(false);
  }

  // Fetch initial cart data from the API
  Future<void> fetchCartData() async {
    int userId = box.read('userId');
    final response = await http.get(Uri.parse('https://dummyjson.com/carts/user/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['carts'] != null && data['carts'].isNotEmpty) {
        cartData.value = data['carts'][0];
        totalProductCount.value = getTotalProductCount();
        box.write('cartData', cartData.value); // Store cart data locally
      } else {
        logger.e("Carts key not found or is empty in the data.");
      }
    } else {
      Get.snackbar('Error', 'Failed to load cart data');
    }
    isLoading(false);
  }

  // Increment quantity of a product
  void incrementQuantity(int index) {
    if (cartData['products'][index] != null) {
      cartData['products'][index]['quantity']++;
      cartData.refresh();
      box.write('cartData', cartData.value); 

    }
  }

  // Decrement quantity of a product
  void decrementQuantity(int index) {
    if (cartData['products'][index] != null && cartData['products'][index]['quantity'] > 1) {
      cartData['products'][index]['quantity']--;
      cartData.refresh();
      box.write('cartData', cartData.value);
    }
  }

 void addItemToCart(Map<String, dynamic> newItem) {
  cartData['products'] ??= [];
  
  List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(cartData['products']);

  int existingIndex = products.indexWhere((product) => product['id'] == newItem['id']);

  if (existingIndex >= 0) {
    products[existingIndex]['quantity']++;
  } else {
    products.add({...newItem, 'quantity': 1});
  }

  // Update 'products' in cartData and write to storage
  cartData['products'] = products;
  cartData.refresh();  // Refresh to notify listeners
  box.write('cartData', cartData.value); 


  // Show success message
  Get.snackbar('Success!', 'Added product to Cart!', backgroundColor: const Color.fromARGB(255, 120, 224, 124));

  // Update total product count
  totalProductCount.value = getTotalProductCount();
}


  // Delete item from cart
  void deleteItemFromCart(int index) {
    var products = cartData['products'] as List;
    products.removeAt(index);
    cartData.refresh();
    box.write('cartData', cartData.value); 
    totalProductCount.value = getTotalProductCount();
  }

  // Calculate total product count
  int getTotalProductCount() {
    return (cartData['products'] != null) ? cartData['products'].length : 0;
  }

void completeOrder() {

    cartData.value = {
      'products': [],
      'total': 0,
      'discountedTotal': 0,
      'totalQuantity': 0,
    };
    cartData.refresh();
    
    box.write('cartData', cartData.value);
    
    totalProductCount.value = 0;

  
  }
  


}
