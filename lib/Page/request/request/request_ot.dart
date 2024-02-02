import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
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
              title: Text('รายการขอโอที'),
            ),
            body: ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  String status = '';
                  String status2 = '';
                  var approveName = docList[index].approveName;
                  var indentStatus = docList[index].status;
                  var indentStatus2 = docList[index].status2;
                  String _itemStatus='';
                  if (indentStatus == 'W') {
                    _itemStatus = 'W';
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    _itemStatus= 'A';
                    status = 'อนุมัติเเล้ว';
                  } else if (indentStatus2 == 'W') {
                    _itemStatus= 'W';
                    status2 = 'รออนุมัติ';
                  } else if (indentStatus2 == 'A') {
                    _itemStatus= 'A';
                    status2 = 'อนุมัติเเล้ว';
                  } else {
                    _itemStatus = 'N';
                    status2 = 'ไม่อนุมัติ';
                    status = 'ไม่อนุมัติ';
                  }
                  List _Status = ['$status','$status2'];
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
                                      Text(
                                          'ชื่อ - สกุล: ${docList[index].employee!.firstName} ${docList[index].employee!.lastName}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'เวลาเริ่มต้น: ${docList[index].startDate} ${docList[index].startTime}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'เวลาสิ้นสุด: ${docList[index].endDate} ${docList[index].endTime}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'ประเภทการโอที: ${docList[index].ot!.otName}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'รายละเอียด: ${docList[index].description == '' ? 'ไม่มีรายระเอียด' : docList[index].description}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        children: [
                                          Text('สถานะ: '),
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
                                              trailing: Text('${_Status[index]}',
                                                  style: TextStyle(
                                                      color: _Status == 'W'
                                                          ? Colors.amber
                                                          : _Status == 'A'
                                                              ? Colors.green
                                                              : Colors.red)),
                                            );
                                          }),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                // approveList[index].status == 'A' ||
                                //         approveList[index].status == 'N'
                                //     ? Container()
                                //     : ButtonTwoAppprove(
                                //         onPressBtSucess: () async {
                                //           try {
                                //             setState(() {
                                //               loading = true;
                                //             });
                                //                String statuscode = 'A';
                                //           var response =
                                //               await Approve_Service()
                                //                   .model(
                                //                       approveList[index]
                                //                           .docLId
                                //                           .toString(),
                                //                           statuscode,
                                //                       token
                                //                       );
                                //           if (response == 200) {
                                //             SharedPrefs();
                                //             Dialog_Tang()
                                //                 .approveSuccessdialog(
                                //                     context);
                                //           } else {
                                //             Dialog_Tang()
                                //                 .falsedialog(context);
                                //           }
                                //           } catch (e) {
                                //             Dialog_Tang().interneterrordialog(context);
                                //             log(e.toString());
                                //           }finally{
                                //             setState(() {
                                //               loading = false;
                                //             });
                                //           }

                                //         },
                                //         onPressBtcal: () {},
                                //       ),
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
