// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, unused_import
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Page/Home/Drawer/Dayoff_page.dart';
import 'package:eztime_app/Page/Home/Drawer/coachMark/coachMark.dart';
import 'package:eztime_app/Page/Home/Drawer/download_document/download_cocument_page.dart';
import 'package:eztime_app/Page/Home/Drawer/menudrawer/leaveandtime/timemenu.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Setting_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Appeove_document_AllPage.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot/Request_OT_approval.dart';
import 'package:eztime_app/Page/documents/salary_calculation.dart';
import 'package:eztime_app/Page/login/SetDomain_Page.dart';
import 'package:eztime_app/Page/login/login_Page.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart%20';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var device_token;
  var _acessToken;
  var _resetToken;
  var _New_Token;
  var fname;
  var lname;
  var userid;
  var ip;
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final myInheritedWidget = MyDrawer();
    // เก็บอ้างอิงของวิดเจ็ตที่เปิดใช้งานไว้ที่นี่
  }

  Future logOutModul() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _acessToken = prefs.getString('_acessToken');
      device_token = prefs.getString('notifyToken');
      String url = '${connect_api().domain}/deleteNotifyToken';
      var response = await Dio().post(url,
          data: {'device_token': device_token},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_acessToken",
          }));
      log('MyDrawerresponse: ${response.statusCode}');
      if (response.statusCode == 200) {
        log('MyDrawerresponse: ${response.data}');
        setState(() {
          prefs.remove('_acessToken');
          prefs.remove('notifyToken');
          prefs.remove('username');
          prefs.remove('password');
          prefs.remove('isAppOpened');
          prefs.remove('pincode');
          Navigator.of(context)
              .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => login_Page()),
                  (route) => false)
              .then((va) {
            if (va == null) {
              loading = false;

              Snack_Bar(
                      snackBarIcon: Icons.check_circle_rounded,
                      snackBarColor: Colors.green,
                      snackBarText: 'homepage.logout')
                  .showSnackBar(context);
            } else {
              loading = false;

              Snack_Bar(
                      snackBarIcon: Icons.check_circle_rounded,
                      snackBarColor: Colors.green,
                      snackBarText: 'homepage.logout')
                  .showSnackBar(context);
            }
          });
        });
      } else {
        setState(() {
          loading = false;
          Snack_Bar(
                  snackBarIcon: Icons.info,
                  snackBarColor: Colors.red,
                  snackBarText: 'homepage.logoutfailed')
              .showSnackBar(context);
          print('Error: ${response.statusCode}');
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        loading = false;
        Snack_Bar(
                snackBarIcon: Icons.info,
                snackBarColor: Colors.red,
                snackBarText: 'homepage.catch')
            .showSnackBar(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => login_Page()),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizewidth = MediaQuery.of(context).size.width;
    return loading
        ? LoadingComponent()
        : SafeArea(
            child: Drawer(
              backgroundColor: Colors.white,
              width: sizewidth * 0.7,
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Image.asset(
                      'assets/logo/Eztime_logo_blue_png.png',
                      scale: 2.8,
                    ),
                    Text(
                      'Drawer.Menu',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ).tr(),
                    Divider(),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => Profile_Page());
                        },
                        icons: Icon(Bootstrap.person_square),
                        title: 'Drawer.Edit'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => time_manu_page());
                        },
                        icons: Icon(Icons.edit_document),
                        title: 'Drawer.Manage_time'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => RequestAll_Page());
                        },
                        icons: Icon(Bootstrap.journal_text),
                        title: 'Drawer.offer_Document'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => Appeove_document_All_Page());
                        },
                        icons: Icon(Bootstrap.journal_check),
                        title: 'Approve_documents.title'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => document_download_page());
                        },
                        icons: Icon(Icons.description_outlined),
                        title: 'Drawer.Report'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => salary_calculation());
                        },
                        icons: Icon(Bootstrap.wallet2),
                        title: 'Drawer.salary summary'),
                    ListCmn(
                        tap: () {
                          Get.back();
                          Get.to(() => setting_page());
                        },
                        icons: Icon(Icons.settings),
                        title: 'Drawer.setting'),
                    ListCmn(
                        tap: () {
                          logOutModul();
                        },
                        icons: Icon(
                          Bootstrap.door_open_fill,
                          color: Colors.red,
                        ),
                        title: 'Drawer.logout'),
                  ],
                ),
              ),
            ),
          );
  }
}

class ListCmn extends StatelessWidget {
  final VoidCallback tap;
  final Icon icons;
  final String title;
  const ListCmn(
      {super.key, required this.tap, required this.icons, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 25,
      minTileHeight: 45,
      onTap: tap,
      iconColor: Theme.of(context).primaryColor,
      leading: icons,
      title: Text(
        title,
        style: TextStyles.textStyleDrawer,
        // overflow: TextOverflow.ellipsis,
      ).tr(),
    );
  }
}
