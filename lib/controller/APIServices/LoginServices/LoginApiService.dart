import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/login/login_Model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginApiService {
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
    device_token = prefs.getString('notifyToken');
    ip = prefs.getString('ip');
    try {
      String url = '${connect_api().domain}/Login_Employee_Mobile';
      var response = await Dio().post(url, data: {
        'employee_no': username,
        'password': password,
        'device_token': device_token
      });
      if (response.statusCode == 200) {
        loginModel Model = loginModel.fromJson(response.data);
        prefs.setString('_acessToken', "${Model.token}");
        await prefs.setString('_resetToken', "${Model.refreshToken}");
        debugPrint('responsedebugPrintin: ${response.statusCode}');
        debugPrint('response acessToken: ${Model.token}');
        debugPrint('responserefreshToken: ${Model.refreshToken}');
        return response.statusCode;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return e;
    }
  }
}
