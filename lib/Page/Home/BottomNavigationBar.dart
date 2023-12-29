// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_new, use_build__synchronously, avoid_single_cascade_in_expression_statements, prefer_const_literals_to_create_immutables, unused_import, unused_field, unused_element
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Login/Login_Model.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications_Detail.dart';
import 'package:eztime_app/Page/Splasscreen/Face_data_Page.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Setting/Drawer.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
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
  bool _ishomeBlue = false;
  bool _notiblue = false;
  bool _article = false;
  bool _menu = false;
  int selectedIndex = 0;
  bool loading = false;
  int coutMessage = 0;
  var image;
  bool? serviceEnabled;
  LocationPermission? permission;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _bodies = <Widget>[
    Home_Page(),
    promble_page(),
    NotiFications_Detail_Page(),
    Container()
  ];
  var username;
  var password;
  var device_token;
  var ip;
  var pin_number;
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

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      device_token = prefs.getString('_deviceToken');
      ip = prefs.getString('ip');
      pin_number = prefs.getString('pincode');
      _OnStartpin();
    });
  }

  Future refresh_Login() async {
    try {
      String url = '${connect_api().domain}/login';
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
          prefs.setString('_deviceToken', '${device_token}');
        });
      } else {
        // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาด
      }
    } catch (error) {
      // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาดในการเรียก API
    }
  }

  Future<void> openImages(ImageSource typeImage) async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: typeImage,
        maxHeight: 1080,
        maxWidth: 1080,
      );
      if (photo != (null)) {
        List<int> imageBytes = await photo.readAsBytes();
        var ImagesBase64 = await convert.base64Encode(imageBytes);
        setState(() {
          if (mounted) {
            image = ImagesBase64;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Set_work(image: image),
              ),
            );
          } else {
            print("No image is selected.sdasdas");
          }
          loading = false;
        });
      } else {
        print("No image is selected.");
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("Error while picking file. $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future _opencamera() async {
    await Permission.camera.request();
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      await Permission.location.request();
      permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied) {
        PermissionStatus serviceEnabled = await Permission.location.status;
        if (serviceEnabled.isDenied) {
          AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.warning,
              title: 'อนุญาตการเข้าถึง',
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              desc: 'อนุญาตเข้าถึงตำแหน่งของคุณ',
              btnOkText: 'เปิดตั้งค่า',
              btnOkOnPress: () {
                openAppSettings();
              },
              btnCancelOnPress: () {
                Navigator.of(context).canPop();
              })
            ..show();
        } else {
          openImages(ImageSource.camera);
          // image = await ImagePickerCamera().pickImage();
          //     log('image : ${image}');
        }
      } else {
        AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            title: 'อนุญาตการเข้าถึง',
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            desc: 'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
            btnOkOnPress: () {
              openAppSettings();
            },
            btnCancelOnPress: () {
              Navigator.of(context).canPop();
            })
          ..show();
      }
    } else {
      AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: 'อนุญาตการเข้าถึง',
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          desc: 'กรุณาอนุญาตเข้าถึงกล้องในอุปกรณ์ของคุณ',
          btnOkOnPress: () {
            openAppSettings();
          },
          btnCancelOnPress: () {
            Navigator.of(context).canPop();
          })
        ..show();
    }
  }

  @override
  void initState() {
    InternetConnectionChecker().checker();
    _OnStartpin();
    shareprefs();
    super.initState();
    _ishomeBlue = true;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            endDrawer: MyDrawer(),
            body: Center(child: _bodies.elementAt(selectedIndex)),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(
                          () {
                            selectedIndex = 0;
                            _notiblue = false;
                            _ishomeBlue = true;
                            _article = false;
                            _menu = false;
                            InternetConnectionChecker().checker();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.home,
                        color: _ishomeBlue ? Colors.blue : Colors.grey,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(
                          () {
                            selectedIndex = 1;
                            _notiblue = false;
                            _ishomeBlue = false;
                            _article = true;
                            _menu = false;
                            InternetConnectionChecker().checker();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.article_rounded,
                        color: _article ? Colors.blue : Colors.grey,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 60),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            color: _notiblue ? Colors.blue : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = 2;
                              _notiblue = true;
                              _menu = false;
                              _ishomeBlue = false;
                              _article = false;
                              InternetConnectionChecker().checker();
                            });
                          },
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  coutMessage == 0 ? Colors.white : Colors.red,
                            ),
                            child: coutMessage == 0
                                ? null
                                : Text(
                                    '${coutMessage}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: _menu ? Colors.blue : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        _notiblue = false;
                        _menu = true;
                        _ishomeBlue = false;
                        _article = false;
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _opencamera();
              },
              tooltip: 'Open Camera',
              child: Icon(Icons.camera_alt_outlined),
              // elevation: 4.0,
            ),
          );
  }
}
