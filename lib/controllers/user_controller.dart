import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:project1/models/user_model.dart';


class UserController extends GetxController {
  final box = GetStorage();
  var user = Rx<User?>(null);
  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    var userId = box.read('userId');


    try {
      http.Response response = await http.get(
        Uri.tryParse('https://dummyjson.com/user/$userId')!,
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var currentUser = User.fromJson(result);
        user.value = currentUser;
      } else {
        logger.e("Failed to fetch user data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error while fetching data: $e");
    }
  }
}
