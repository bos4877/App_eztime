import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/menu_page.dart';
import 'package:eztime_app/Page/documents/request/improve_uptime/request_improve_uptime/improve_uptime.dart';
import 'package:eztime_app/Page/documents/request/leave/request_leave/leave_Request.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot/ot_request.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/logOut/Logout_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestAll_Page extends StatefulWidget {
  const RequestAll_Page({super.key});

  @override
  State<RequestAll_Page> createState() =>
      _RequestAll_PageState();
}

class _RequestAll_PageState extends State<RequestAll_Page> {
  bool loading = false;
  @override
  void initState() {
    loading = true;
    // TODO: implement initState
    super.initState();
    Shareprefs();
  }

  var _getToken;
  var get_typeuser;
  Future Shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = await prefs.getString('_acessToken');
    get_typeuser = await prefs.getString('employetype');
    setState(() {
      loading = false;
    });
  }

//-------------------------------------------------------------------------------------------------------------------------------
  List<Widget> _listPage = [
    leave_request_page(),
    ot_request_page(),
    request_edit_uptime(),
  ];
  // List<IconData> _listIconPage = [];
  List<String> _listpageName = [
    'Leaverequestlist.title',
    'ot_request.title',
    'Improve_Uptime.title'
  ];
//-------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return  loading
            ? LoadingComponent()
            : Scaffold(
                body: MenuPageComponents(
                  title: 'homepage.Document_list',
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
                              Bootstrap.journal_plus,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('${_listpageName[index]}',style: TextStyle(fontSize: 20),).tr(),
                          ],
                        ),
                        onTap: () {
                          get_Device_token_service()
                              .model(_getToken)
                              .then((value) {
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
              )
                );
  }
}


class card_requestAll extends StatelessWidget {
  final String title;
  final VoidCallback tap;
  final notificationCount;
  const card_requestAll(
      {super.key,
      required this.title,
      required this.tap,
      this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        trailing: notificationCount == 0 || notificationCount == null
            ? CircleAvatar(
                backgroundColor: Colors.transparent,
              )
            : CircleAvatar(
                radius: 15,
                backgroundColor: Colors.red,
                child: Text("${notificationCount.toString()}",
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(color: Colors.white, blurRadius: 0.2)
                    ])),
              ),
        minLeadingWidth: 4.0,
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ).tr(),
        iconColor: Theme.of(context).primaryColor,
        leading: Icon(Icons.description_outlined),
        onTap: tap,
      ),
    );
  }
}
