import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/alert_image/allow_access/Not_Access/not_access_status.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Components/menu_page/menu_page.dart';
import 'package:eztime_app/Page/documents/appeove/improve_uptime/tapbar_apporv_improve_uptime.dart';
import 'package:eztime_app/Page/documents/appeove/leave/tapbar_apporv_leave.dart';
import 'package:eztime_app/Page/documents/appeove/ot/tapbar_apporv_ot.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/logOut/Logout_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appeove_document_All_Page extends StatefulWidget {
  const Appeove_document_All_Page({super.key});

  @override
  State<Appeove_document_All_Page> createState() =>
      _Appeove_document_All_PageState();
}

class _Appeove_document_All_PageState extends State<Appeove_document_All_Page> {
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
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = await prefs.getString('_acessToken');
    get_typeuser = await prefs.getString('employetype');
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      loading = false;
    });
  }

//-------------------------------------------------------------------------------------------------------------------------------
  List<Widget> _listPage = [
    tapbar_apporv_leave(),
    tapbar_apporv_ot(),
    tapbar_apporv_improve_uptime(),
  ];
  // List<IconData> _listIconPage = [];
  List<String> _listpageName = [
    'Approve_leave.title',
    'OT_request_list.tapName',
    'Apporv_Improve_Uptime.title'
  ];
//-------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        get_typeuser == 'normal_admin'
            ? Scaffold(
                body: MenuPageComponents(
                title: 'Approve_documents.title',
                subtitle: card_loading_CPN(
                  loading: loading,
                  chid: ListView.builder(
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
                                Bootstrap.card_checklist,
                                size: 40,
                                color: Theme.of(context).primaryColor,
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
                ),
              ))
            : Scaffold(
                body: Stack(
                  children: [
                    card_loading_CPN(
                      loading: loading,
                      chid: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: not_access(),
                      ),
                    ),
                    MyAppBar(pagename: 'Approve_documents.title'),
                  ],
                ),
              ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }
}
