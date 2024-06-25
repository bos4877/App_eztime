import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/menu_page.dart';
import 'package:eztime_app/Page/Home/Drawer/Dayoff_page.dart';
import 'package:eztime_app/Page/Home/Drawer/menudrawer/leaveandtime/workingTime_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/documents/request/leave/Leave_quota/Leave_quota_page.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/logOut/Logout_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class time_manu_page extends StatefulWidget {
  const time_manu_page({super.key});

  @override
  State<time_manu_page> createState() => _time_manu_pageState();
}

class _time_manu_pageState extends State<time_manu_page> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loading = true;
    Shareprefs();
  }

  var _getToken;
  Future Shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = await prefs.getString('_acessToken');
   await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

//-------------------------------------------------------------------------------------------------------------------------------
  List<Widget> _listPage = [
    working_time_Page(),
    TableBasicsExample(),
    Information_login(),
    Leave_quota_page()
  ];
  List<IconData> _listIconPage = [
    Bootstrap.hourglass_split,
    Bootstrap.calendar_event,
    Bootstrap.clock_history,
    Bootstrap.clipboard_data,
  ];
  List<String> _listpageName = [
    'Manage_time.working_time',
    'Manage_time.holidays',
    'Manage_time.ClockIn/Out',
    'Manage_time.leavequota',
  ];
//-------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: MenuPageComponents(
          title: 'Manage_time.title',
          subtitle: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: _listPage.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.grey.shade200,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(style: BorderStyle.none)),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        _listIconPage[index],
                        size: 40,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${_listpageName[index]}',
                        style: TextStyle(fontSize: 20),
                      ).tr(),
                    ],
                  ),
                  onTap: () {
                    get_Device_token_service().model(_getToken).then((value) {
                      if (value != '') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _listPage[index],
                        ));
                      } else {
                        logOut_service().model(context);
                      }
                    });
                  },
                ),
              );
            },
          ),
        )),
            loading
        ? LoadingComponent(
          )
        : SizedBox()
      ],
    );
  }
}
