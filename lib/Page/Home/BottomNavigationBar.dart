// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_new, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Setting/Drawer.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/NotiFications.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart%20';

class BottomNavigationBar_Page extends StatefulWidget {
  const BottomNavigationBar_Page({super.key});

  @override
  BottomNavigationBar_PageState createState() =>
      BottomNavigationBar_PageState();
}

class BottomNavigationBar_PageState extends State<BottomNavigationBar_Page> {
  // Explicit
  bool _showDrawer = false;
  bool _ishomeBlue = false;
  bool _notiblue = false;
  bool _article = false;
  bool _menu = false;
  int selectedIndex = 0;
  bool loading = false;
  final ImagePicker imgpicker = ImagePicker();
  String? image;
  bool? serviceEnabled;
  LocationPermission? permission;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ImagePickerComponent _imagePickerComponent = ImagePickerComponent();
  // Method
  final List<Widget> _bodies = <Widget>[
    Home_Page(),
    promble_page(),
    notification_page(),
    Container()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> openImages(ImageSource typeImage) async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: typeImage,
        maxHeight: 1080,
        maxWidth: 1080,
      );
      if (photo != null) {
        List<int> imageBytes = await photo.readAsBytes();
        String imagesBase64 = convert.base64Encode(imageBytes);
        image = imagesBase64;
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Set_work(image: image),
          ));
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
              desc: 'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
              btnOkText: 'เปิดตั้งค่า',
              btnOkOnPress: () {
                openAppSettings();
              },
              btnCancelOnPress: () {
                Navigator.of(context).canPop();
              })
            ..show();
        } else {
          print('object');
          openImages(ImageSource.camera);
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
    super.initState();
    _ishomeBlue = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  setState(() {
                    selectedIndex = 0;
                    _notiblue = false;
                    _ishomeBlue = true;
                    _article = false;
                    _menu = false;
                  });
                },
                icon: Icon(
                  Icons.home,
                  color: _ishomeBlue ? Colors.blue : Colors.grey,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                    _notiblue = false;
                    _ishomeBlue = false;
                    _article = true;
                    _menu = false;
                  });
                },
                icon: Icon(
                  Icons.article_rounded,
                  color: _article ? Colors.blue : Colors.grey,
                  size: 30,
                ),
              ),
              SizedBox(width: 60),
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
                  });
                },
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
        child: SizedBox(child: Icon(Icons.camera_alt_outlined)),
        // elevation: 4.0,
      ),
    );
  }
}
