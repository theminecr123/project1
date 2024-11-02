import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/order_controller.dart';
class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['id']}'),
            Text('Date: ${order['createdAt']}'),
            Text('Total Products: ${order['productCount']}'),
            Text('Total: \$${order['total'].toStringAsFixed(2)}'),
            Divider(),
            Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order['products'].map<Widget>((product) {
              return ListTile(
                title: Text(product['title']),
                subtitle: Text('Quantity: ${product['quantity']}'),
                trailing: Text('\$${product['price']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
