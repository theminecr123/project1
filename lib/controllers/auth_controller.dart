import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/home_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AuthController instance = Get.find();




  // Login function
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => HomePage());  

    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }


  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Account created successfully", backgroundColor: Colors.green, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);
      Get.offAll(() => LoginPage());  
    } on FirebaseAuthException catch (e) {

      if(e.code == "weak-password")
        Get.snackbar("Error", "Weak Password!", backgroundColor: Colors.red, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);
      else if(e.code == "email-already-in-use")
        Get.snackbar("Error", "Email has used!", backgroundColor: Colors.red, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);

    
    }catch(e){
      Get.snackbar("Error", "Error!: $e", backgroundColor: Colors.red, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);
      print(e);
    }
  }
}
