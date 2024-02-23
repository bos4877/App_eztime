// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, unused_import
import 'dart:developer';
import 'dart:math' as math;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Page/Home/Drawer/Dayoff_page.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Setting_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/Login/SetDomain_Page.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/salary_calculation.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Future Sharefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _acessToken = prefs.getString('_acessToken');
      device_token = prefs.getString('_deviceToken');
      _resetToken = prefs.getString('_resetToken');
      fname = prefs.getString('firstName');
      lname = prefs.getString('lastName');
      userid = prefs.getString('userid');
    ip = prefs.getString('ip');
      log(_resetToken);
      log('device_token: ${device_token}');
      log('_acessToken: ${_acessToken}');
    });
  }

  Future logOutModul() async {
    try {
      setState(() {
        _loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
  void initState() {
    super.initState();
    Sharefs();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 250,
      elevation: 8,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "$userid",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              accountEmail: Text(
                "$fname $lname",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage('assets/background/person-png-icon-29.jpg')),
                      
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile_Page(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_personal_available.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'Drawer.Edit',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Request_leave(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_attendance_available.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'Drawer.Request leave',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Request_OT_approval(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_attendance_available.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'Drawer.Get approval, Ot',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Information_login(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_time.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'Drawer.Summarize',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TableBasicsExample(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_attendance_available.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'ปฏิทิน',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () async {
                await Permission.storage.request();
                PermissionStatus status = await Permission.storage.status;
                if (status.isGranted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => salary_calculation(),
                  ));
                } else {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.warning,
                    title: 'DiaLog.titleinternet'.tr(),
                    titleTextStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    desc: 'DiaLog.Allowaccess'.tr(),
                    btnCancelText: 'DiaLog.cancle'.tr(),
                    btnOkText: 'DiaLog.opensetting'.tr(),
                    btnCancelOnPress: () {
                      
                    },
                    btnOkOnPress: () {
                      openAppSettings();
                    },
                    dismissOnBackKeyPress: false,
                    dismissOnTouchOutside: false,
                  )..show();
                }
              },
              leading: SvgPicture.asset(
                'assets/icons_Svg/money-bag.svg',
                color: Colors.blue,
                width: 50,
                height: 23,
              ),
              title: Text(
                'Drawer.salary summary',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => setting_page(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_setting.png',
                color: Colors.blue,
                scale: 30,
              ),
              title: Text(
                'Drawer.setting',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                logOutModul();
              },
              leading: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: SvgPicture.asset(
                  'assets/icons_Svg/logout.svg',
                  color: Colors.red,
                  width: 50,
                  height: 20,
                ),
              ),
              title: Text(
                'Drawer.Logout',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
            ListTile(
              minLeadingWidth: 25,
              horizontalTitleGap: 0,
              onTap: () {
                // Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => test(),
                ));
              },
              leading: Image.asset(
                'assets/icon_easytime/1x/icon_X.png',
                color: Colors.red,
                scale: 30,
              ),
              title: Text(
                'เทส',
                style: TextStyles.textStyleDrawer,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
