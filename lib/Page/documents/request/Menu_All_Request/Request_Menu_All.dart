import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/Error_dialog/logout_error_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/menu_page.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart'
    as ot;
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart'
    as addtime;
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart'
    as leave;
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart'
    as oneleave;
import 'package:eztime_app/Page/documents/request/improve_uptime/tapbar_apporv_improve_uptime.dart';
import 'package:eztime_app/Page/documents/request/leave/tapbar_logrequest_leave.dart';
import 'package:eztime_app/Page/documents/request/ot/tapbar_logrequest_ot.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_Menu_All_Page extends StatefulWidget {
  const Request_Menu_All_Page({super.key});

  @override
  State<Request_Menu_All_Page> createState() => _Request_Menu_All_PageState();
}

class _Request_Menu_All_PageState extends State<Request_Menu_All_Page> {
  bool loading = false;
  List<oneleave.Data> employeeleave = [];
  List<leave.Data> leaveList = [];
  List<ot.Data> ot_list = [];
  List<addtime.Data> _addtime = [];
  int ot_Count = 0;
  int leave_cout = 0;
  int _addtimeCount = 0;
  int Approval_authority_leave = 0;
  int Approval_authority_ot = 0;
  int Approval_authority_adtime = 0;
  int employeeleaveCount = 0;
  SharedPreferences? prefs;
  String? _getToken;
  @override
  void initState() {
   loading = true;
    // TODO: implement initState
    super.initState();
     loadDataFromSharedPreferences();
     
  }

  Future loadDataFromSharedPreferences() async {
    setState(() {
      loading = true;
    });
    
    prefs = await SharedPreferences.getInstance();
    _getToken = prefs!.getString('_acessToken');
    print(
        'Data For Request_Menu_All_Page: $_getToken'); // ดึงข้อมูลจาก SharedPreferences ด้วยคีย์ 'responseData'
   
    setState(() {
      loading = false;
    });
  }

  Future get_leaveandot() async {
    try {
      setState(() {
        loading = true;
      });
       await Future.delayed(Duration(milliseconds: 300));
      var get_ot = await get_doc_Ot_list_one_Service().model(_getToken,context);
      var get_doc_leave = await get_DocOne_Service().model(_getToken);
      var getleave_One = await get_DocOne_Service().model(_getToken);
      var get_addtime = await get_addtime_list_Service().model(_getToken);
      await Future.delayed(Duration(milliseconds: 500));
      leaveList = get_doc_leave;
      employeeleave = getleave_One;
      ot_list = get_ot;
      _addtime = get_addtime;

      for (var i = 0; i < leaveList.length; i++) {
        
      }
      int countLeaveW =
          leaveList.where((leave) => leave.status == 'waiting').length;
      Approval_authority_leave = leaveList
          .where((leave) => leave.docApprove?[0].status == 'waiting')
          .length;
      int countot_listW =
          ot_list.where((otcount) => otcount.status == 'waiting').length;
      Approval_authority_ot = ot_list
          .where((ot_approv_count) =>
              ot_approv_count.docApprove![0].status == 'waiting')
          .length;
      Approval_authority_adtime = _addtime
          .where((adtime_approv_count) =>
              adtime_approv_count.docApprove![0].status == 'waiting')
          .length;
      int countaddtimeW =
          _addtime.where((adtime) => adtime.status == 'waiting').length;
      ot_Count = countot_listW;
      _addtimeCount = countaddtimeW;
      loading = false;
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  List<Widget> _listPage = [
    tapbar_logrequest_leave(),
    tapbar_logrequest_ot(),
    tapbar_request_improve_uptime(),
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
    return Stack(
      children: [
        Scaffold(
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
                                Text(
                                  '${_listpageName[index]}',
                                  style: TextStyle(fontSize: 20),
                                ).tr(),
                              ],
                            ),
                            onTap: () {
                              get_Device_token_service()
                                  .model(_getToken!)
                                  .then((value) {
                                if (value != '') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => _listPage[index],
                                  ));
                                } else {
                                  logout_error_dialog().show(context);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  )
            ),
            loading
            ? LoadingComponent()
            : SizedBox()
      ],
    );
  }
}
