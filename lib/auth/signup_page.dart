import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/controllers/auth_controller.dart';

class SignupPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Create", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
                  Text("your account", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Enter your name"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email address"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirm password"),
              obscureText: true,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text == confirmPasswordController.text) {
                  _authController.signUp(emailController.text.trim(), passwordController.text.trim());
                } else {
                  Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red, colorText: Colors.white, snackPosition:SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(45, 32, 28, 1),
              ),
              child: Text("SIGN UP", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Text("or sign up with", textAlign: TextAlign.center),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon("assets/images/apple-icon.png"),
                _buildSocialIcon("assets/images/facebook-icon.png"),
                _buildSocialIcon("assets/images/google-icon.png"),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed("/login");

                },
                child: Text("Already have an account? Log In"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}
