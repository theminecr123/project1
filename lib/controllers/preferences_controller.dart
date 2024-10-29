import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController extends GetxController {
  var isFirstLaunch = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isFirstLaunch.value = prefs.getBool('first_launch') ?? true;

      if (isFirstLaunch.value) {
        // Set first launch to false
        await prefs.setBool('first_launch', false);
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }
}