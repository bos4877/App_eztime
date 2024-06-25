import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Page/Home/Drawer/Drawer.dart';
import 'package:eztime_app/Page/Home/Drawer/download_document/download_cocument_page.dart';
import 'package:eztime_app/Page/Home/Drawer/menudrawer/leaveandtime/timemenu.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Setting_Page.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Appeove_document_AllPage.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/documents/salary_calculation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {},
      ),
    );
  }
}

class bottomsheettest {
  void show(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    showModalBottomSheet<void>(
      shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Drawer.Menu',
                style: TextStyle(color: Colors.grey),
              ).tr(),
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
                  tap: () async {
                    try {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
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
                        prefs.remove('_acessToken');
                        prefs.remove('notifyToken');
                        prefs.remove('username');
                        prefs.remove('password');
                        prefs.remove('isAppOpened');
                        prefs.remove('pincode');
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => login_Page()),
                            (context) => false);
                        Snack_Bar(
                                snackBarIcon: Icons.check_circle_rounded,
                                snackBarColor: Colors.green,
                                snackBarText: 'homepage.logout')
                            .showSnackBar(context);
                      } else {
                        Snack_Bar(
                                snackBarIcon: Icons.info,
                                snackBarColor: Colors.red,
                                snackBarText: 'homepage.logoutfailed')
                            .showSnackBar(context);
                        print('Error: ${response.statusCode}');
                      }
                    } catch (e) {
                      Snack_Bar(
                              snackBarIcon: Icons.info,
                              snackBarColor: Colors.red,
                              snackBarText: 'homepage.catch')
                          .showSnackBar(context);
                    }
                  },
                  icons: Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                  title: 'Drawer.logout'),
            ],
          ),
        );
      },
    );
  }
}
