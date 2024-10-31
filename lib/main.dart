import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/config/MainNavigation.dart';
import 'package:project1/intro_pages/onboarding_page.dart';
import 'controllers/preferences_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import get_storage
import 'intro_pages/welcome_scene.dart';
import 'ui/home_page.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage
  Get.put(PreferencesController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferencesController preferencesController = Get.find();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        if (preferencesController.isFirstLaunch.value) {
          return WelcomePage();
        } else if (preferencesController.isLoggedIn.value) {
          


        
          
          return MainLayout(); 
        } else {
          return LoginPage(); 
        }
      }),
    );
  }

}
