import 'dart:convert';
import 'package:get/get.dart';
import 'package:project1/models/cart_model.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var isLoading = false.obs;
  CartModel? _cartModel;

  // Fetch cart data
  fetchData() async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse('https://dummyjson.com/carts')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        _cartModel = CartModel.fromJson(result);
      } else {
        print("Error fetching data!");
      }
    } catch (e) {
      print("Error while fetching data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Add to cart method
  Future<void> addToCart(int productId, int quantity) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('https://dummyjson.com/carts/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "productId": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200) {
        print("Product added to cart!");
        fetchData(); // Refresh cart data after adding
      } else {
        print("Failed to add product to cart");
      }
    } catch (e) {
      print("Error adding product to cart: $e");
    } finally {
      isLoading(false);
    }
  }
}
