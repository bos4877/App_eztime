// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_unnecessary_containers, unused_local_variable, body_might_complete_normally_nullable
import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Background/Background.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/Model/Company/Company_Model.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Login/Login_Model.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/main.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart%20';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  InternetConnectionStatus? _connectionStatus;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  var _isObscured;
  var _refreshToken;
  var _token;
  var ip;
  ReceivePort port = ReceivePort();
  String? deviceToken;

  void _getDeviceToken() async {
    // final messing = FirebaseInstanceId.getInstance().getToken(“old-sender-id”, FirebaseMessaging.INSTANCE_ID_SCOPE);
    deviceToken = await messing.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString('ip');
  }

  Future loginUser(
      String username, String password, String device_token) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        String url = '${connect_api().domain}/login_employee';
        var response = await Dio().post(url, data: {
          'user_name': username,
          'password': password,
          'device_token': device_token
        });
        if (response.statusCode == 200) {
          // ทำสิ่งที่คุณต้องการกับข้อมูลที่ได้รับที่นี่
          var Jsonres = response.data;
          LoginModel tokenModel = LoginModel.fromJson(Jsonres);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            
            prefs.setString('_acessToken', "${tokenModel.token}");
            prefs.setString('_resetToken', '${tokenModel.refreshToken}');
            prefs.setString('_deviceToken', '${deviceToken}');
            prefs.setString('username', _username.text);
            prefs.setString('password', _password.text);
            _loading = false;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BottomNavigationBar_Page(),
            ));
            Snack_Bar(
                    snackBarIcon: Icons.check_circle_rounded,
                    snackBarColor: Colors.green,
                    snackBarText: 'homepage.loginSuccess')
                .showSnackBar(context);
          });
        } else {
          // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาด
          setState(() {
            _loading = false;
            Snack_Bar(
                    snackBarIcon: Icons.info,
                    snackBarColor: Colors.red,
                    snackBarText: 'homepage.loginfailed')
                .showSnackBar(context);
                 print('Error : ${response.statusCode}');
          });
        }
      } catch (error) {
        // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาดในการเรียก API
              if (error is DioError) {
                if (error.response!.statusCode == 517) {
                    Snack_Bar(
                  snackBarIcon: Icons.warning_amber_rounded,
                  snackBarColor: Colors.red,
                  snackBarText: 'homepage.catch')
              .showSnackBar(context);
                } else {
                  
                }
        
      } else {
        return error;
      }
      
        setState(() {
          _loading = false;

              print('catch : ${error}');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().checker();
    _getDeviceToken();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: MediaQuery.of(context).size.height * 0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Image(
                    image: AssetImage('assets/background/Asset_1.png'),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      labelText: "ชื่อผู้ใช้งาน",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ชื่อผู้ใช้งาน!!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: TextFormField(
                    obscureText: _isObscured,
                    controller: _password,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.key_rounded,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: _isObscured
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )),
                      labelText: "รหัสผ่าน",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน!!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Buttons(
                    title: 'เข้าสู่ระบบ',
                    press: () async {
                      // await check_connect();
                      await loginUser(
                          _username.text, _password.text, '${deviceToken}');
                    }),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'หากยังไม่ได้เป็นสมาชิก HIP EASY TIME?',
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // เซ็ตสี overlay เป็นโปร่งใส
                      ),
                      onPressed: () {},
                      child: Text('ติดต่อฝ่ายทะเบียน'),
                    )
                  ],
                ),
                _loading ? Loading() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
