// ignore_for_file: unnecessary_null_comparison

import 'dart:convert' as convert;
import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart%20';

class Home_Page_controller extends GetxController {
  var loading = false.obs;
  var image = ''.obs;
  var serviceEnabled = false.obs;
  var permission = LocationPermission.denied.obs;
  var isExpanded = true.obs;
  var timeFormat = DateTime.now().obs; // เปลี่ยนประเภทข้อมูลตามต้องการ
  var dateFormatter = DateTime.now().obs; // เปลี่ยนประเภทข้อมูลตามต้องการ
  final ImagePicker imgpicker = ImagePicker();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}

class imagePage extends GetxController {
   var image = "".obs;
  final ImagePicker imgpicker = ImagePicker();
  var loading = RxBool(false);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

Future openImages(ImageSource TypeImage) async {
  try {
    loading.value = true;
    final XFile? photo = await imgpicker.pickImage(
        source: TypeImage, maxHeight: 1080, maxWidth: 1080);
    List<int> imageBytes = await photo!.readAsBytes();
    var ImagesBase64 = convert.base64Encode(imageBytes);
    if (photo != null) {
      image.value =  ImagesBase64;
      loading.value = false;
      log(image.toString());
    } else {
      print("No image is selected.");
      loading.value = false;
    }
  } catch (e) {
    log("error while picking file. ${e}");
    loading.value = false;
  }
}
}
class Format_Date extends GetxController{
  var _dateformatter;
  String? _timeformat;
  @override
  void onInit() {
    _formatdate();
    // TODO: implement onInit
    super.onInit();
  }
    Future _formatdate() async {
    DateTime _date = DateTime.now();
    DateTime _time = DateTime.now();
    _dateformatter =
        DateFormat.yMMMMEEEEd().formatInBuddhistCalendarThai(_date).obs;
    _timeformat = DateFormat.Hms().format(_time);
    print(_dateformatter);
  }
}
