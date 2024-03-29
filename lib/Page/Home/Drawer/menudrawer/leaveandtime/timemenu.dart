import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/Drawer/Dayoff_page.dart';
import 'package:eztime_app/Page/Home/Drawer/menudrawer/leaveandtime/workingTime_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class time_manu_page extends StatelessWidget {
  const time_manu_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Manage_time.title').tr(),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) => BottomNavigationBar_Page(),
              ),);
            },
            icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                minLeadingWidth: 4.0,
                title: Text(
                  'Manage_time.working_time',
                  style: TextStyle(fontSize: 14),
                ).tr(),
                iconColor: Theme.of(context).primaryColor,
                leading: Icon(Icons.timer_outlined),
                onTap: () {
                  Get.to(()=> working_time_Page());
                },
              ),
            ),
            Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                minLeadingWidth: 4.0,
                title: Text(
                  'Manage_time.Calendar',
                  style: TextStyle(fontSize: 14),
                ).tr(),
                iconColor: Theme.of(context).primaryColor,
                leading: Icon(Icons.calendar_month_outlined),
                onTap: () {
                  Get.to(() =>TableBasicsExample());
                },
              ),
            ),
            Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                minLeadingWidth: 4.0,
                title: Text(
                  'Manage_time.ClockIn/Out',
                  style: TextStyle(fontSize: 14),
                ).tr(),
                iconColor: Theme.of(context).primaryColor,
                leading: Icon(Icons.timelapse_sharp),
                onTap: () {
                  Get.to(() =>Information_login());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
