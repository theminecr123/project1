import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PreferencesController extends GetxController {
  var isFirstLaunch = true.obs;

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
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }
}
