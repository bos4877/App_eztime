// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_unnecessary_containers, unused_local_variable, body_might_complete_normally_nullable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Background/Background.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/check_internet/checker_internet_service.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/Company_Model.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Model/login/login_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/controller/APIServices/loginServices/loginApiService.dart';
import 'package:eztime_app/controller/GexController/doubleTwocloseApp/doubleTwocloseApp.dart';
import 'package:eztime_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart%20';
import 'package:shared_preferences/shared_preferences.dart';

class login_Page extends StatefulWidget {
  const login_Page({super.key});

  @override
  State<login_Page> createState() => _login_PageState();
}

class _login_PageState extends State<login_Page> {
  final doubleTwocloseApp _getcontroller = Get.put(doubleTwocloseApp());
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
    log('deviceToken: ${deviceToken}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString('ip');
  }

  Future loginUser(
      String username, String password, String device_token) async {
    if (await Utility.getInstance()!.checkNetwork() == 'none') {
      //Dialog_internetError.showCustomDialog(context);
    } else {
      if (_formkey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        try {
          String url = '${connect_api().domain}/login_Employee';
          var response = await Dio().post(url, data: {
            'employee_no': username,
            'password': password,
            'device_token': device_token
          });
          if (response.statusCode == 200) {
            // ทำสิ่งที่คุณต้องการกับข้อมูลที่ได้รับที่นี่
            var Jsonres = response.data;
            loginModel tokenModel = loginModel.fromJson(Jsonres);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              prefs.setString('_acessToken', "${tokenModel.token}");
              prefs.setString('_resetToken', '${tokenModel.refreshToken}');
              prefs.setString('_deviceToken', deviceToken!);
              prefs.setString('username', username);
              prefs.setString('password', password);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationBar_Page(),
                  ),
                  (route) => false);
              _loading = false;
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
                      snackBarIcon: Icons.info_outline_rounded,
                      snackBarColor: Colors.red,
                      snackBarText: 'homepage.errorDivice')
                  .showSnackBar(context);
            } else if (error.response!.statusCode == 401) {
              Snack_Bar(
                      snackBarIcon: Icons.warning_amber_rounded,
                      snackBarColor: Colors.red,
                      snackBarText: 'homepage.loginfailed')
                  .showSnackBar(context);
            } else {
              Snack_Bar(
                      snackBarIcon: Icons.warning_amber_rounded,
                      snackBarColor: Colors.red,
                      snackBarText: 'homepage.catch')
                  .showSnackBar(context);
            }
          } else {
            return error;
          }

          setState(() {
            print('catch : ${error}');
          });
        }
      }
    }
  }
//   Future<bool> myAsyncFunction() async {
//   // ดำเนินการเป็นซิงโครนัสและคืนค่า boolean
//   bool result = await someSynchronousOperation();
//   return Future<bool>.value(result);
// }

  @override
  void initState() {
    super.initState();
    _getDeviceToken();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return _loading
        ? LoadingComponent()
        : WillPopScope(
            onWillPop: () async {
              _getcontroller.increment();
              _getcontroller.checkAndChangeCount();
              if (_getcontroller.count.value == 2) {
                return Future<bool>.value(true);
              } else {
                Snack_Bar(
                        snackBarColor: Colors.grey.shade800,
                        snackBarIcon: Icons.info,
                        snackBarText: 'homepage.exit')
                    .showSnackBar(context);
                return Future<bool>.value(false);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                   Image.asset(
                                'assets/logo_app/eztime_logo_CircleAvatar_W.png',scale: 4,),
                        // SizedBox(height: 15),
                        // SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            autofocus: false,
                            controller: _username,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: "ชื่อผู้ใช้งาน",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
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
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: TextFormField(
                            autofocus: false,
                            obscureText: _isObscured,
                            controller: _password,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: Icon(
                                Icons.key_rounded,
                                color: Theme.of(context).primaryColor,
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
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Theme.of(context).primaryColor,
                                        )),
                              labelText: "รหัสผ่าน",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
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
                        SizedBox(height: 30),
                        Buttons(
                            title: 'เข้าสู่ระบบ',
                            press: () async {
                              // await check_connect();
                              await loginUser(_username.text, _password.text,
                                  '${deviceToken}');
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
                                overlayColor: MaterialStateProperty.all(Colors
                                    .transparent), // เซ็ตสี overlay เป็นโปร่งใส
                              ),
                              onPressed: () {},
                              child: Text('ติดต่อฝ่ายทะเบียน'),
                            )
                          ],
                        ),
                        _loading ? LoadingComponent() : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
