import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/intro_pages/onboarding_page.dart';
import 'controllers/preferences_controller.dart';
import 'package:get/get.dart';
import 'intro_pages/welcome_scene.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(PreferencesController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final PreferencesController preferencesController = Get.put(PreferencesController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/welcome', page: () => WelcomePage()),

      ],


      home: Obx((){
        return preferencesController.isFirstLaunch.value ? WelcomePage() : LoginPage();
      })
    );
  }
}


