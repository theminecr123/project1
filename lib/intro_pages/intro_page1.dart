import 'package:flutter/material.dart';
import 'package:project1/auth/login_page.dart';
import 'package:get/get.dart';

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top half
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      Text(
                        'Discover something new',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Special new arrivals just for you',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom half
              Expanded(
                child: Container(
                  color: Colors.grey[850],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(()=>LoginPage());
                        },
                        child: Text('Shopping now'),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                      ),
                    )
                   
                  ),
                ),
              ),
            ],
          ),
          // Card with image
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage('assets/images/intro1.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
