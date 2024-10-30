import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartController.fetchCartData();  // Fetch cart data whenever dependencies change
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final products = cartController.cartData['products'];
        if (products == null || products.isEmpty) {
          return Center(child: Text('Cart is empty'));
        }

        // Display the products
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: product['thumbnail'] != null
                            ? Image.network(
                                product['thumbnail'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(width: 50, height: 50, color: Colors.grey),
                        title: Text(
                          product['title'] ?? 'No Title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${product['price'] ?? '0.00'}'),
                            Text('Quantity: ${product['quantity'] ?? '1'}'),
                            Text('Total: \$${(product['price'] * product['quantity']).toStringAsFixed(2)}'), 
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => cartController.decrementQuantity(index),
                            ),
                            Text('${product['quantity'] ?? '1'}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => cartController.incrementQuantity(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Footer with Total and Checkout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product price', style: TextStyle(fontSize: 16)),
                      Text('\$${cartController.cartData['total'] ?? '0.00'}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${cartController.cartData['discountedTotal'] ?? '0.00'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Handle checkout
                    },
                    child: Text('Proceed to checkout',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
