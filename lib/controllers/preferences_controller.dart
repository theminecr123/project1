import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PreferencesController extends GetxController {
  var isFirstLaunch = true.obs;
  var isLoggedIn = false.obs; // Track user login status

  @override
  void onInit() {
    super.onInit();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    try {
      final box = GetStorage();
      isFirstLaunch.value = box.read('first_launch') ?? true;

      if (isFirstLaunch.value) {
        // Set first launch to false
        await box.write('first_launch', false);
      }

      // After checking first launch, check if user is logged in
      checkUserLoggedIn();
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  Future<void> checkUserLoggedIn() async {
    final box = GetStorage();
    final String? token = box.read('userToken'); // Replace with your key

    isLoggedIn.value = token != null; // Set logged in status based on token
  }
}
