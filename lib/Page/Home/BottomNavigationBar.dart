// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_new, use_build__synchronously, avoid_single_cascade_in_expression_statements, prefer_const_literals_to_create_immutables, unused_import, unused_field, unused_element
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/Components/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/Components/APIServices/getFaceRecog/getFaceRecog.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/getFaceRecog_Model/getFaceRecog_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Login/Login_Model.dart';
import 'package:eztime_app/Page/Approve/Submit_documents.dart';
import 'package:eztime_app/Page/Approve/original_Employee.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Setting/Drawer.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications_Detail.dart';
import 'package:eztime_app/Page/Splasscreen/Face_data_Page.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart%20';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationBar_Page extends StatefulWidget {
  const BottomNavigationBar_Page({super.key});

  @override
  BottomNavigationBar_PageState createState() =>
      BottomNavigationBar_PageState();
}

class BottomNavigationBar_PageState extends State<BottomNavigationBar_Page> {
  bool _showDrawer = false;
  bool loading = false;
  int coutMessage = 0;
  var image;
  bool? serviceEnabled;
  List<EmployData> _profilelist = [];
  LocationPermission? permission;
  getFaceRecog_Model member = getFaceRecog_Model();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var username;
  var password;
  var device_token;
  var ip;
  var pin_number;
  var token;
  var _bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.article_rounded,
    Icons.notifications_active_outlined,
    Icons.menu,
  ];
  final List<Widget> _bodies = <Widget>[
    Home_Page(),
    Information_login(),
    NotiFications_Detail_Page(),
  ];
  var _profileService = get_profile_service();
  Future getprofile() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('_acessToken');
      var response = await _profileService.getprofile(token);
      setState(() {
        log(response.toString());
        if (response == null) {
          Dialog_Tang().infodialog(context);
          log('faile');
          setState(() {
            loading = false;
          });
        } else {
          _profilelist = [response];
          log('success');
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      loading = false;
      log(e.toString());
      // Dialog_Tang().dialog(context);
    }
  }

  Future _OnStartpin() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    if (pin_number == null) {
      setState(() {
        loading = false;
        return null;
      });
    } else {
      setState(() {
        loading = false;
        Pin_code().sceenlog(context);
      });
    }
  }

  var service;
  shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      device_token = prefs.getString('_deviceToken');
      ip = prefs.getString('ip');
      pin_number = prefs.getString('pincode');
      token = prefs.getString('_acessToken');
      getprofile();
      _OnStartpin();
    });
  }



 

  @override
  void initState() {
    InternetConnectionChecker().checker();
    _OnStartpin();
    shareprefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            endDrawer: MyDrawer(),
            body: Center(child: _bodies.elementAt(_bottomNavIndex)),
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                activeIndex: _bottomNavIndex,
                itemCount: iconList.length,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                onTap: (index) {
                  index == 3
                      ? _scaffoldKey.currentState?.openEndDrawer()
                      : setState(() {
                          log('index:${index}');
                          if (index == 1) {
                            if (_profilelist[0].role == '') {
                              index = 1;
                            } else {
                              _bottomNavIndex = index;
                            }
                          }
                          _bottomNavIndex = index;
                        });
                },
                tabBuilder: (int index, bool isActive) {
                  return Icon(
                    iconList[index],
                    size: 24,
                    color: isActive ? Colors.blue : Colors.grey,
                  );
                  //other params
                }),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.miniCenterDocked,
            // floatingActionButton:
          );
  }
}
