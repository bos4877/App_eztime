import 'package:eztime_app/controller/GexController/checkInternet_GetX/NetworkController.dart.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}