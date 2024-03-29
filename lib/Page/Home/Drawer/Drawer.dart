// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, unused_import
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/NavigationService/NavigationService.dart';
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
import 'package:eztime_app/Page/login/SetDomain_Page.dart';
import 'package:eztime_app/Page/login/login_Page.dart';
import 'package:eztime_app/Page/submit_documents/Submit_documents/Appeove_document_AllPage.dart';
import 'package:eztime_app/Page/submit_documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/request_leave/Request_leave.dart';
import 'package:eztime_app/Page/submit_documents/request/ot/request_ot/Request_OT_approval.dart';
import 'package:eztime_app/Page/submit_documents/salary_calculation.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
  bool _loading = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final myInheritedWidget = MyDrawer();
  // เก็บอ้างอิงของวิดเจ็ตที่เปิดใช้งานไว้ที่นี่
}
  Future logOutModul() async {
    try {
      setState(() {
        _loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _acessToken = prefs.getString('_acessToken');
      device_token = prefs.getString('_deviceToken');
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
          prefs.remove('_deviceToken');
          prefs.remove('username');
          prefs.remove('password');
          prefs.remove('isAppOpened');
          prefs.remove('pincode');
          // Get.offAllNamed('$homepage_name');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Domain_Set_Page()),
              (route) => false);
          _loading = false;
        });

        Snack_Bar(
                snackBarIcon: Icons.check_circle_rounded,
                snackBarColor: Colors.green,
                snackBarText: 'homepage.logout')
            .showSnackBar(context);
      } else {
        setState(() {
          _loading = false;
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
        _loading = false;
        Snack_Bar(
                snackBarIcon: Icons.info,
                snackBarColor: Colors.red,
                snackBarText: 'homepage.catch')
            .showSnackBar(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? LoadingComponent(): Drawer(   
      backgroundColor: Colors.white,
      width: 250,
      elevation: 8,
      shape:
          BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              actions: [Container(
                
              )],
            ),
            // UserAccountsDrawerHeader(
            //   accountName: Text(
            //     "$userid",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ).tr(),
            //   accountEmail: Text(
            //     "$fname $lname",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ).tr(),
            //   // currentAccountPicture: CircleAvatar(
            //   //     backgroundColor: Colors.white,
            //   //     backgroundImage:
            //   //         AssetImage('assets/background/person-png-icon-29.jpg')),
            // ),
            ListCmn(
                tap: () {
                  Get.back();
                  Get.to(() => Profile_Page());
                },
                icons: Icon(Icons.person),
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
                icons: Icon(Icons.description_outlined),
                title: 'Drawer.offer_Document'),
                                 ListCmn(
                tap: () {
                  Get.back();
                  Get.to(() => Appeove_document_All_Page());
                },
                icons: Icon(Icons.description_outlined),
                title: 'อนุมัติเอกสาร'),
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
                icons: Icon(Icons.attach_money_rounded),
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
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                title: 'Drawer.logout'),
          ],
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
      horizontalTitleGap: 0,
      onTap: tap,
      iconColor: Theme.of(context).primaryColor,
      leading: icons,
      title: Text(
        title,
        style: TextStyles.textStyleDrawer,
        overflow: TextOverflow.ellipsis,
      ).tr(),
    );
  }
}
