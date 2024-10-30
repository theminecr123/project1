import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CartController extends GetxController {
  final box = GetStorage();
  var cartData = {}.obs;
  var isLoading = true.obs;
  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
  int userId = box.read('userId');
  final response = await http.get(Uri.parse('https://dummyjson.com/carts/user/$userId'));

  logger.i("Fetching cart data for userId: $userId");
  logger.i("Response status: ${response.statusCode}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['carts'] != null && data['carts'].isNotEmpty) {
      cartData.value = data['carts'][0]; 
    } else {
      logger.e("Carts key not found or is empty in the data.");
    }

    isLoading(false); 
  } else {
    Get.snackbar('Error', 'Failed to load cart data');
    isLoading(false);
  }
}


  void incrementQuantity(int index) {
    if (cartData['products'][index] != null) {
      cartData['products'][index]['quantity']++;
      cartData.refresh();  
    }
  }

  void decrementQuantity(int index) {
    if (cartData['products'][index] != null && cartData['products'][index]['quantity'] > 1) {
      cartData['products'][index]['quantity']--;
      cartData.refresh(); 
    }
  }

  Future<void> addItemToCart(Map<String, dynamic> newItem) async {
  int userId = box.read('userId') ?? 1; // Get the userId
  final response = await http.post(
    Uri.parse('https://dummyjson.com/carts/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'userId': userId,
      'products': [newItem], // Add the new item to the products list
    }),
  );

  if (response.statusCode == 200) {
    logger.i("Item added: ${response.body}");
    fetchCartData(); // Refresh cart data after adding the item
  } else {
    logger.e("Failed to add item. Status Code: ${response.statusCode}");
    Get.snackbar('Error', 'Failed to add item to cart');
  }
}


Future<void> updateItemInCart(int cartId, int productId, int quantity) async {
  final response = await http.put(
    Uri.parse('https://dummyjson.com/carts/update/$cartId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'products': [
        {
          'id': productId,
          'quantity': quantity, // Update the quantity for this product
        }
      ],
    }),
  );

  if (response.statusCode == 200) {
    logger.i("Item updated: ${response.body}");
    fetchCartData(); // Refresh cart data after updating
  } else {
    logger.e("Failed to update item. Status Code: ${response.statusCode}");
    Get.snackbar('Error', 'Failed to update item in cart');
  }
}

Future<void> deleteItemFromCart(int cartId, int productId) async {
  final response = await http.delete(
    Uri.parse('https://dummyjson.com/carts/remove/$cartId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'id': productId, // The product ID to be deleted
    }),
  );

  if (response.statusCode == 200) {
    logger.i("Item deleted: ${response.body}");
    fetchCartData(); // Refresh cart data after deletion
  } else {
    logger.e("Failed to delete item. Status Code: ${response.statusCode}");
    Get.snackbar('Error', 'Failed to delete item from cart');
  }
}

}
