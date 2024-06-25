import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/face/getFaceRecog_Model/getFaceRecog_Model.dart';
import 'package:flutter/material.dart';

class getFaceRecog_Service {
  model(BuildContext context, token) async {
    try {
      String url = '${connect_api().domain}/get_Face_Recognizing';
      var response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        getFaceRecog_Model data = getFaceRecog_Model.fromJson(response.data);
        log('get_Face_Recognizing: ${response.statusCode}');
        return data.count!.toInt();
      } else {
        log('get_Face_Recognizing: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionError:
          false_dialog(
            detail: 'ตรวจสอบการเชื่อมต่อ อินเทอร์เน็ต',
          ).show(context);
          break;
        case DioExceptionType.connectionTimeout:
          false_dialog(
            detail: 'เชื่อมต่อ เชิร์ฟเวอร์ล้มเหลว',
          ).show(context);
          break;
      }
    }
  }
}
