import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_ot_page extends StatefulWidget {
  const Request_ot_page({super.key});

  @override
  State<Request_ot_page> createState() => _Request_ot_pageState();
}

class _Request_ot_pageState extends State<Request_ot_page> {
  bool loading = false;
  List<DocList> docList = [];
  var token;
  @override
  void initState() {
    SharedPrefs();
    // TODO: implement initState
    super.initState();
  }

  SharedPrefs() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('_acessToken');
      await get_ot();
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future get_ot() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await get_doc_Ot_list_one_Service().model(token);
      docList = response;
    } catch (e) {
      log(e.toString());
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
              title: Text('OTrequestlist.title').tr(),
            ),
            body: ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  String status;
                  var docotApprove = docList[index].docOtApprove;
                  var indentStatus = docList[index].status;
                  String _itemStatus='';
                  if (indentStatus == 'W') {
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    status = 'อนุมัติเเล้ว';
                  } else {
                    status = 'ไม่อนุมัติ';
                  }
                  return Column(
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
                                    '${docList[index].employee!.firstName} ${docList[index].employee!.lastName}',
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
                                  Text('${status}',
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
                                      Row(
                                        children: [
                                          Text('OTrequestlist.name').tr(),
                                          Text(
                                              ' ${docList[index].employee!.firstName} ${docList[index].employee!.lastName}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('OTrequestlist.starttime').tr(),
                                          Text(
                                              ' ${docList[index].startDate} ${docList[index].startTime}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('OTrequestlist.endTime').tr(),
                                          Text(
                                              ' ${docList[index].endDate} ${docList[index].endTime}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('OTrequestlist.Leavetype').tr(),
                                          Text(
                                              ' ${docList[index].ot!.otName}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('OTrequestlist.details').tr(),
                                          Text(
                                              ' ${docList[index].description == '' ? 'ไม่มีรายระเอียด' : docList[index].description}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        children: [
                                          Text('OTrequestlist.status').tr(),
                                          Text('$status',
                                              style: TextStyle(
                                                  color: indentStatus == 'W'
                                                      ? Colors.amber
                                                      : indentStatus == 'A'
                                                          ? Colors.green
                                                          : Colors.red)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('OTrequestlist.Person with approval').tr(),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: docotApprove!.length,
                                          itemBuilder: (context, index) {
                                              String appoveStatus;
                                            var appeoveStatus =
                                                docotApprove[index].status;
                                            if (appeoveStatus == 'W') {
                                              appoveStatus = 'รออนุมัติ';
                                            } else if (appeoveStatus == 'A') {
                                              appoveStatus = 'อนุมัติเเล้ว';
                                            } else {
                                              appoveStatus = 'ไม่อนุมัติ';
                                            }
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              leading: Text(
                                                  '${docotApprove[index].approveFname} ${docotApprove[index].approveLname}'),
                                              trailing: Text('${appoveStatus}',
                                                  style: TextStyle(
                                                      color: appeoveStatus == 'W'
                                                          ? Colors.amber
                                                          : appeoveStatus == 'A'
                                                              ? Colors.green
                                                              : Colors.red)),
                                            );
                                          }),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ]);
                }));
  }
}
