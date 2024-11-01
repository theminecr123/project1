import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/controllers/cart_controller.dart';
import 'package:project1/controllers/order_controller.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/ui/completed_page.dart';

class CheckoutStep2 extends StatefulWidget {
  @override
  _CheckoutStep2State createState() => _CheckoutStep2State();
}

class _CheckoutStep2State extends State<CheckoutStep2> {
  final UserController userController = Get.put(UserController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());

  bool agreeToTerms = true;
  final box = GetStorage();
  late var total = box.read("total") ?? 0.0;
  late var shipCost = box.read("shipCost") ?? 0.0;
   late Map<String, dynamic> cartData = box.read("cartData") ?? {};
  @override
  Widget build(BuildContext context) {
    final user = userController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Check out'),
        actions: [Icon(Icons.menu)],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("STEP 2", style: TextStyle(color: Colors.grey)),
            Text("Payment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            // Credit Card Design
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blue[700], // Card background color
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("VISA", style: TextStyle(color: Colors.white, fontSize: 20)),
                  Spacer(),
                  Text(
                      formatCardNumber(user?.bank.cardNumber ?? ''),

                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user?.firstName} ${user?.lastName}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "${user?.bank.cardExpire}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextButton(onPressed: () {}, child: Text("Add new")),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              title: Text("Product price"),
              trailing: Text(
                "\$${total.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              title: Text("Shipping"),
              trailing: Text(
                "\$${shipCost.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              title: Text("Subtotal"),
              trailing: Text(
                "\$${(shipCost + total).toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            CheckboxListTile(
              value: agreeToTerms,
              onChanged: (value) {
                setState(() {
                  agreeToTerms = value ?? false;
                });
              },
              title: Text("I agree to Terms and conditions"),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: agreeToTerms
                    ? () {
                        orderController.saveOrder(cartData);
                        Get.to(() => CheckoutStep3());

                        // cartController.completeOrder();
                       

                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Payment", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCardNumber(String cardNumber) {
  String masked = cardNumber.length > 4
      ? '*' * (cardNumber.length - 4) + cardNumber.substring(cardNumber.length - 4)
      : cardNumber;

  return masked.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
}
}
