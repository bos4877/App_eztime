import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class doubleTwocloseApp extends GetxController {
    // สร้างสถานะที่ต้องการจัดการ
  var count = 0.obs;

  // เพิ่มเมธอดสำหรับเพิ่มค่า count
  void increment() => count++;

  // เมธอดเพื่อตรวจสอบเงื่อนไขและเปลี่ยนค่า count
  void checkAndChangeCount() {
    log('count.value: ${count.value}');
    if (count.value == 2) {
      // ทำการเปลี่ยนค่า count ตามเงื่อนไขที่คุณต้องการ
      count.value = 2; // เปลี่ยนค่า count เป็น 10
      SystemNavigator.pop();
       log('message1: ${count.value}');
    } else {
      // ทำการเปลี่ยนค่า count ตามเงื่อนไขที่คุณต้องการ
      
      count.value++; // เปลี่ยนค่า count เป็น 5
      log('message2: ${count.value}');
    }
  }

}
