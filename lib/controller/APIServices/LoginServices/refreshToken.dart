import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/controller/APIServices/LoginServices/LoginApiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class refreshToken {
  model() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var resetToken = await prefs.getString('_resetToken');
   var token = prefs.getString('_acessToken');
    debugPrint('checkresetToken ${resetToken}');
    debugPrint('Tokenrefresh: ${token}');
    var service = await loginApiService();
    try {
      String url = '${connect_api().domain}/refreshTokenMobile';
      var response = await Dio().post(url,
          data: {"refreshToken": resetToken},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        refreshToken_Model model = refreshToken_Model.fromJson(response.data);
        prefs.setString('_acessToken', "${model.token}");
        prefs.setString('_resetToken', "${model.refreshToken}");
        if (model.token!.isNotEmpty) {
          return model.token;
        } else {
          service.fetchData();
        }
      } else {
        await service.fetchData();
      }
    } on DioError catch (e) {
      await service.fetchData();
    }
  }
}
