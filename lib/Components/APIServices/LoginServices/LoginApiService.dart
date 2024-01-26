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
        String url = '${connect_api().domain}/login_employee';
        var response = await Dio().post(url, data: {
          'employee_no': username,
          'password': password,
          'device_token': device_token
        });
      if (response.statusCode == 200) {
        LoginModel tokenModel = LoginModel.fromJson(response.data);
       prefs.setString('_acessToken', "${tokenModel.token}");
       prefs.setString('_resetToken', "${tokenModel.refreshToken}");
       log('responseLogin: ${response.statusCode}');
        return response.statusCode;
      }else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return e;
    }
  }
}

