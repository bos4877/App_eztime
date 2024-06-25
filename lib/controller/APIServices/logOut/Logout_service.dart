import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logOut_service {
  model(BuildContext puscontext)async{
    try {
       SharedPreferences prefs = await SharedPreferences.getInstance();
     var _acessToken = prefs.getString('_acessToken');
     var device_token = prefs.getString('notifyToken');
      String url = '${connect_api().domain}/deleteNotifyToken';
      var response = await Dio().post(url,
          data: {'device_token': device_token},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_acessToken",
          }));
      if (response.statusCode == 200) {
          prefs.remove('notifyToken');
          prefs.remove('username');
          prefs.remove('password');
          prefs.remove('isAppOpened');
          prefs.remove('pincode');
         Navigator.pushAndRemoveUntil(puscontext, MaterialPageRoute(builder: (context) => login_Page(),), (route) => false);
          
      }
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('notifyToken');
          prefs.remove('username');
          prefs.remove('password');
          prefs.remove('isAppOpened');
          prefs.remove('pincode');
          Navigator.pushAndRemoveUntil(puscontext, MaterialPageRoute(builder: (context) => login_Page(),), (route) => false);
  
    }
    
  }
}