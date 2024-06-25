import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class countController extends GetxController {
  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCount();
    update();
  }

  void incrementCount() {
    count.value++;
    saveCount();
    loadCount();
    update();
  }

  void clearCount() {
    count.value = 0;
    saveCount();
    update();
  }

  void saveCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('count', count.value);
    update();
  }

  void loadCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    count.value = prefs.getInt('count') ?? 0;
    update();
  }
}
