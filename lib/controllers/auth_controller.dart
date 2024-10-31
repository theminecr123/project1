import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/config/MainNavigation.dart';
import 'package:project1/ui/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final Logger logger = Logger();
  final box = GetStorage();

  // Login function using API
  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
          
        }),
        
        
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        logger.i("Response data: $userData");

        final String token = userData['accessToken'];
        final int userId = userData['id'];
        await box.write('userToken', token);
        await box.write('userId', userId);

        Get.offAll(() => MainLayout());
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid email or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Logout function
  Future<void> logout() async {
    // Clear user session or token here
    Get.offAll(() => LoginPage());
  }

  // Signup function (Example, adapt as per your API)
  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/register'),  // Replace with the actual signup endpoint
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Account created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => LoginPage());
      } else {
        Get.snackbar(
          "Signup Failed",
          "Email already in use or weak password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error!: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
    }
  }
}
