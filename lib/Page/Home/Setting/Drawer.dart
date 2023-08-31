// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Setting_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/salary_calculation.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('id');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login_Page()),
        (route) => false);
  }

  // on_Goback() {
  //   setState(() {

  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 200,
      elevation: 8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(6),
              //       bottomRight: Radius.circular(6)),
              //   color: Colors.blue,
              // ),
              accountName: Text(
                "Employee Id.employee Id",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              accountEmail: Text(
                "Employee Id.Name",
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
                  builder: (context) => salary_calculation(),
                ));
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
                logout(context);
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
                Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => FlutterPinCodeFields(),
                // ));
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
