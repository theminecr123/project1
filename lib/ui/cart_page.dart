import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/cart_controller.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.put(CartController());

  // Calculate total price
  double calculateTotal() {
    double total = 0.0;
    for (var product in cartController.cartData['products']) {
      total += (product['price'] ?? 0) * (product['quantity'] ?? 1);
    }
    return total;
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

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];

                  return Dismissible(
                    key: Key(product['id'].toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      cartController.deleteItemFromCart(index);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Padding(
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
                              Text('Total: \$${((product['price'] ?? 0) * (product['quantity'] ?? 1)).toStringAsFixed(2)}'), 
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
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 16)),
                      Text('\$${calculateTotal().toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
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
                    child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white)),
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
