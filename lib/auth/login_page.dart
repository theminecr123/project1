import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController _authController = Get.put(AuthController());
  final TextEditingController username = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // State variable for password visibility
  final RxBool _isPasswordVisible = false.obs; // Use Rx to reactively update the UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50, top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Log into", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
                  Text("your account", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: username,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _isPasswordVisible.value = !_isPasswordVisible.value;
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible.value,
                )),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot password action
                },
                child: const Text("Forgot Password?"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _authController.login(username.text.trim(), passwordController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(45, 32, 28, 1),
              ),
              child: const Text(
                "LOG IN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text("or sign in with", textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon("assets/images/apple-icon.png"),
                _buildSocialIcon("assets/images/facebook-icon.png"),
                _buildSocialIcon("assets/images/google-icon.png"),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed("/signup");
                },
                child: const Text("Don't have an account? Sign Up"),
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
          child: Image.asset(assetPath, height: 20, width: 20),
        ),
      ),
    );
  }
}
