import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/approve_ot/approve_ot_Service.dart';
import 'package:eztime_app/Components/APIServices/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class approve_ot_page extends StatefulWidget {
  const approve_ot_page({super.key});

  @override
  State<approve_ot_page> createState() => _approve_ot_pageState();
}

class _approve_ot_pageState extends State<approve_ot_page> {
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<DocList> docList = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_ot();
  }

  Future _get_ot() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneOt = await get_doc_Ot_list_one_Service().model(token);
      docList = getoneOt;
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('รายการโอที'),
            ),
            body: ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  String status;
                  var approveName = docList[index].approveName;
                  var indentStatus = docList[index].status;
                  if (indentStatus == 'W') {
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    status = 'อนุมัติเเล้ว';
                  } else {
                    status = 'ไม่อนุมัติ';
                  }
                  return docList[index].status == 'W'
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
                                          '${docList[index].ot!.otName}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ).tr(),
                                      ],
                                    ),
                                    onExpansionChanged: (expanded) async {
                                      setState(() {
                                        expanded = false;
                                      });
                                    },
                                    trailing: Column(
                                      children: [
                                        //  !expanOpen ?
                                        Text('$status',
                                            style: TextStyle(
                                                color: indentStatus == 'W'
                                                    ? Colors.amber
                                                    : indentStatus == 'A'
                                                        ? Colors.green
                                                        : Colors.red))
                                      ],
                                    ),
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
                                                'เวลาเริ่มต้น: ${docList[index].startDate} ${docList[index].startTime}'),
                                            Text(
                                                'เวลาสิ้นสุด: ${docList[index].endDate} ${docList[index].endTime}'),
                                            Text(
                                                'ประเภทการลา: ${docList[index].ot!.otName}'),
                                            Text(
                                                'รายละเอียด: ${docList[index].description}'),
                                            Text('สถานะ: $status'),
                                            Divider(),
                                            Text('ผู้มีสิทธิ อนุมัติ:'),
                                           ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: approveName!.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  dense: true,
                                                  leading: Text(
                                                      '${approveName[index].firstName} ${approveName[index].lastName}'),
                                                  trailing: Text('$status',
                                                      style: TextStyle(
                                                          color: indentStatus == 'W'
                                                              ? Colors.amber
                                                              : indentStatus == 'A'
                                                                  ? Colors.green
                                                                  : Colors.red)),
                                                );
                                              }
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                      docList[index].status == 'A' ||
                                              docList[index].status == 'N'
                                          ? Container()
                                          : ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                var statuscode = 'A';
                                                var response = await approve_ot_service().model(docList[index].docOtId.toString(), token, statuscode);
                                                  if (response == 200) {
                                                    log('response: ${response}');
                                                  } else {
                                                    Dialog_Tang().falsedialog(context);
                                                    
                                                  }
                                              },
                                              onPressBtcal: () {},
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
          );
  }
}
