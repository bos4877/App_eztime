import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Login/Login_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiService {
  final Dio _dio = Dio();
  
  var username;
  var password;
  var device_token;
  var token;
  var refreshToken;
  var ip;

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    password = prefs.getString('password');
    device_token = prefs.getString('_deviceToken');
    ip = prefs.getString('ip');
    try {
            var response = await _dio.post('${connect_api().domain}/login',
      data: {"user_name": username, "password": password, "device_token":device_token});
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        LoginModel tokenModel = LoginModel.fromJson(response.data);
        prefs.setString('_acessToken', "${tokenModel.token}");
       prefs.setString('_resetToken', "${tokenModel.refreshToken}");
       refreshToken =  prefs.getString('_resetToken');
       token = prefs.getString('_acessToken');
       log('token :${token}');
       log('refreshToken : ${refreshToken}');
        return response.statusCode;
      }else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return e;
    }
  }
}

