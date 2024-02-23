// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, camel_case_types, unused_import, unused_field
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_addtime_list_model%20.dart'
    as addtime;
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class approve_improve_uptime_page extends StatefulWidget {
  const approve_improve_uptime_page({super.key});

  @override
  State<approve_improve_uptime_page> createState() =>
      _approve_improve_uptime_pageState();
}

class _approve_improve_uptime_pageState
    extends State<approve_improve_uptime_page> {
  List<addtime.DocList> _addtime = [];
  bool loading = false;
  var token;
  @override
  void initState() {
    InternetConnectionChecker().checker();
    shareprefs();
    super.initState();
  }

  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
   await get_addtime();
  }

  Future get_addtime() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await get_addtime_list_Service().model(token);
      _addtime = response;
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  Future approve_addtime(add_time_id,status)async{
    setState(() {
      loading = true;
    });
   try {
     String url = '${connect_api().domain}/approve_addtime';
     var response = await Dio().post(url,data: {
      "add_time_id":"$add_time_id",
      "status":'$status'
     },options: Options(headers: {
      "Authorization":"Bearer $token"
     }));
     if (response.statusCode == 200) {
        Dialog_Tang().approveSuccessdialog(context);
     } else {
        Dialog_Tang().falsedialog(context);
     }
   } catch (e) {
      Dialog_Tang().interneterrordialog(context);
      log(e.toString());
   }finally{
    setState(() {
      shareprefs();
      loading = false;
    });
   }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(title: Text('Watch the Ot log.title').tr()),
      body: Container(
        child: ListView.builder(
                itemCount: _addtime.length,
                itemBuilder: (context, index) {
                  var docotApprove = _addtime[index].docAddtimeApprove;
                  String status;
                  var indentStatus = _addtime[index].status;
                  if (indentStatus == 'W') {
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    status = 'อนุมัติเเล้ว';
                  } else {
                    status = 'ไม่อนุมัติ';
                  }
                  return _addtime[index].status == 'W' && docotApprove![0].status == 'W' || docotApprove![0].status == 'N'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Material(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.blue)),
                                  child: ExpansionTile(
                                    maintainState: true,
                                    // initiallyExpanded: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon_easytime/1x/icon_attendance_available.png',
                                          scale: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${_addtime[index].employee!.firstName} ${_addtime[index].employee!.lastName}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ).tr(),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        //  !expanOpen ?
                                        Text('$status',
                                            style: TextStyle(
                                                color: indentStatus == 'W'
                                                    ? Colors.amber
                                                    : indentStatus == 'A'
                                                        ? Colors.green
                                                        : Colors.red)),
                                      ],
                                    ),
                                    onExpansionChanged: (expanded) async {
                                      setState(() {
                                        expanded = false;
                                      });
                                    },
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                                indent: 5,
                                                endIndent: 5),
                                                Text(
                                                'รหัสพนักงาน: ${_addtime[index].employeeNo}'),
                                            Text(
                                                'ชื่อ - สกุล: ${_addtime[index].employee!.firstName} ${_addtime[index].employee!.lastName}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'วันที่: ${_addtime[index].date} ${_addtime[index].time}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'รายละเอียด: ${_addtime[index].description}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('สถานะ: '),
                                                Text('$status',
                                                    style: TextStyle(
                                                        color: indentStatus ==
                                                                'W'
                                                            ? Colors.amber
                                                            : indentStatus ==
                                                                    'A'
                                                                ? Colors.green
                                                                : Colors.red)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: docotApprove!.length,
                                                itemBuilder: (context, index) {
                                                  String appoveStatus;
                                                  var appeoveStatus =
                                                      docotApprove[index]
                                                          .status;
                                                  if (appeoveStatus == 'W') {
                                                    appoveStatus = 'รออนุมัติ';
                                                  } else if (appeoveStatus ==
                                                      'A') {
                                                    appoveStatus =
                                                        'อนุมัติเเล้ว';
                                                  } else {
                                                    appoveStatus = 'ไม่อนุมัติ';
                                                  }
                                                  return ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    dense: true,
                                                    leading: Text(
                                                        '${docotApprove[index].approveFname} ${docotApprove[index].approveLname}'),
                                                    trailing: Text(
                                                        '${appoveStatus}',
                                                        style: TextStyle(
                                                            color: appeoveStatus ==
                                                                    'W'
                                                                ? Colors.amber
                                                                : appeoveStatus ==
                                                                        'A'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red)),
                                                  );
                                                }),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                      _addtime[index].status == 'A' ||
                                              _addtime[index].status == 'N'
                                          ? Container()
                                          : ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                  String statuscode = 'A';
                                                 approve_addtime(_addtime[index].addTimeId.toString(), status);
                                                 
                                              },
                                              onPressBtNotsuc:() async {
                                                  String statuscode = 'N';
                                                 approve_addtime(_addtime[index].addTimeId.toString(), status);
                                                 
                                              },
                                            ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ])
                      : Container();
                }),
      ),
    );
  }
}
