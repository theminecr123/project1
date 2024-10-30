import 'package:get/get.dart';
import 'package:project1/auth/login_page.dart';
import 'package:project1/auth/signup_page.dart';
import 'package:project1/ui/home_page.dart';
import 'package:project1/intro_pages/welcome_scene.dart';

var pages=[
    
  GetPage(name: '/home', page: () => HomePage()),

  GetPage(name: '/welcome', page: () => WelcomePage()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/signup', page: () => SignupPage()),

      
];