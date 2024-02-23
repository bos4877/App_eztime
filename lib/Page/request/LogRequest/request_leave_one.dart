import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/approve_doc/approve.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_leave_page extends StatefulWidget {
  const Request_leave_page({super.key});

  @override
  State<Request_leave_page> createState() => _Request_leave_pageState();
}

class _Request_leave_pageState extends State<Request_leave_page> {
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
      get_leave();
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await get_DocOne_Service().model(token);
      docList = response;
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future delect_doc(id, status, tokenD) async {
    setState(() {
      loading = true;
    });
    try {
      var response = Approve_Service().model(id, status, tokenD);
      if (response == 200) {
        Dialog_Tang().approveSuccessdialog(context);
      } else {
        Dialog_Tang().falsedialog(context);
      }
    } catch (e) {
      Dialog_Tang().interneterrordialog(context);
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
              title: Text('Leaverequestlist.title').tr(),
            ),
            body: ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  String status;
                  var docLeaveApprove = docList[index].docLeaveApprove;
                  var indentStatus = docList[index].status;
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
                                      Wrap(
                                        children: [
                                          Text('Leaverequestlist.name').tr(),
                                          Text(
                                              ' ${docList[index].employee!.firstName} ${docList[index].employee!.lastName}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        children: [
                                          Text('Leaverequestlist.starttime').tr(),
                                          Text(
                                              ' ${docList[index].startDate} ${docList[index].startTime}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('Leaverequestlist.endTime').tr(),
                                          Text(
                                              ' ${docList[index].endDate} ${docList[index].endTime}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('Leaverequestlist.Leavetype').tr(),
                                          Text(
                                              ' ${docList[index].leave!.leaveType}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text('Leaverequestlist.details').tr(),
                                          Text(
                                              ' ${docList[index].description}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        children: [
                                          Text('Leaverequestlist.status').tr(),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Leaverequestlist.picture').tr(),
                                          IconButton(
                                              onPressed: () async {
                                                var bytes;
                                                var service =
                                                    get_pic_docService();
                                                var response =
                                                    await service.model(
                                                        token,
                                                        docList[index]
                                                            .docLId
                                                            .toString());
                                                log(response.toString());
                                                if (response == 'ไม่พบรูปภาพ') {
                                                  Snack_Bar(
                                                          snackBarColor:
                                                              Colors.red,
                                                          snackBarIcon: Icons
                                                              .warning_rounded,
                                                          snackBarText:
                                                              'ไม่มีรูปภาพ')
                                                      .showSnackBar(context);
                                                } else {
                                                  bytes = response;
                                                  return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Container(
                                                          width: 200,
                                                          height: 200,
                                                          child: Image.memory(
                                                              bytes),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.image_outlined,
                                                size: 40,
                                              )),
                                        ],
                                      ),
                                      Text('Leaverequestlist.Person with approval').tr(),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: docLeaveApprove!.length,
                                          itemBuilder: (context, index) {
                                            String appoveStatus;
                                            var appeoveStatus =
                                                docLeaveApprove[index].status;
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
                                                  '${docLeaveApprove[index].approveFname} ${docLeaveApprove[index].approveLname}'),
                                              trailing: Text('$appoveStatus',
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red)),
                                    icon: Icon(Icons.close, size: 12),
                                    label: Text(
                                      'buttons.cancle',
                                      style: TextStyle(fontSize: 10),
                                    ).tr(),
                                    onPressed: () async {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'แจ้งเตือน',
                                        desc: 'ต้องการยกลิกใช่หรือไม่',
                                        btnCancelText: 'ยกเลิก',
                                        btnCancelOnPress: () {},
                                        btnOkText: 'ตกลง',
                                        btnOkOnPress: () {
                                          delect_doc(
                                              docList[index].docLId.toString(),
                                              status,
                                              token);
                                        },
                                      );
                                    },
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
