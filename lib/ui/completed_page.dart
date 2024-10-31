import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/config/MainNavigation.dart';
import 'package:project1/ui/home_page.dart';

class CheckoutStep3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check out'),
        actions: [Icon(Icons.menu)],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              SizedBox(height: 40),
              Text("Order Completed", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Thank you for your purchase. You can view your order in 'My Orders' section.",style: TextStyle(fontSize: 20),),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed:
                    () {
                        Get.offAll(() => MainLayout());
                      }
                    ,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Continue shopping!", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
