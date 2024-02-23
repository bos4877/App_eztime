import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_leave/get_leave_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/GetLeave/getleave.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/approve_doc/approve.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class approve_leave_page extends StatefulWidget {
  const approve_leave_page({super.key});

  @override
  State<approve_leave_page> createState() => _approve_leave_pageState();
}

class _approve_leave_pageState extends State<approve_leave_page> {
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<DocList> approveList = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_leave();
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave = await get_doc_leave_Service().model(token);
      approveList = getoneleave;
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  onGoblack() async {
    try {
      await shareprefs();
    } catch (e) {
    } finally {
      Dialog_Tang().interneterrordialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('รายการลา'),
            ),
            body: ListView.builder(
                itemCount: approveList.length,
                itemBuilder: (context, index) {
                  var docotApprove = approveList[index].docLeaveApprove;
                  String status;
                  var indentStatus = approveList[index].status;
                  if (indentStatus == 'W') {
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    status = 'อนุมัติเเล้ว';
                  } else {
                    status = 'ไม่อนุมัติ';
                  }
                  return approveList[index].status == 'W' && docotApprove![0].status == 'W'
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
                                          '${approveList[index].employee!.firstName} ${approveList[index].employee!.lastName}',
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
                                                'ชื่อ - สกุล: ${approveList[index].employee!.firstName} ${approveList[index].employee!.lastName}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'เวลาเริ่มต้น: ${approveList[index].startDate} ${approveList[index].startTime}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'เวลาสิ้นสุด: ${approveList[index].endDate} ${approveList[index].endTime}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'ประเภทการลา: ${approveList[index].leave!.leaveType}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'รายละเอียด: ${approveList[index].description}'),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('รูปภาพ: '),
                                                IconButton(
                                                    onPressed: () async {
                                                      var bytes;
                                                      var service =
                                                          get_pic_docService();
                                                      var response =
                                                          await service.model(
                                                              token,
                                                              approveList[index]
                                                                  .docLId
                                                                  .toString());
                                                      log(response.toString());
                                                      if (response ==
                                                          'ไม่พบรูปภาพ') {
                                                        Snack_Bar(
                                                                snackBarColor:
                                                                    Colors.red,
                                                                snackBarIcon: Icons
                                                                    .warning_rounded,
                                                                snackBarText:
                                                                    'ไม่มีรูปภาพ')
                                                            .showSnackBar(
                                                                context);
                                                      } else {
                                                        bytes = response;
                                                        return showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Container(
                                                                width: 200,
                                                                height: 200,
                                                                child: Image
                                                                    .memory(
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
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                      approveList[index].status == 'A' ||
                                              approveList[index].status == 'N'
                                          ? Container()
                                          : ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                try {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  String statuscode = 'A';
                                                  var response =
                                                      await Approve_Service()
                                                          .model(
                                                              approveList[index]
                                                                  .docLId
                                                                  .toString(),
                                                              statuscode,
                                                              token);
                                                  if (response == 200) {
                                                   
                                                    Dialog_Tang()
                                                        .approveSuccessdialog(
                                                            context);
                                                  } else {
                                                    Dialog_Tang()
                                                        .falsedialog(context);
                                                  }
                                                } catch (e) {
                                                  Dialog_Tang()
                                                      .interneterrordialog(
                                                          context);
                                                  log(e.toString());
                                                } finally {
                                                  setState(() {
                                                     shareprefs();
                                                    loading = false;
                                                  });
                                                }
                                              },
                                              onPressBtNotsuc: () async {
                                                try {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  String statuscode = 'N';
                                                  var response =
                                                      await Approve_Service()
                                                          .model(
                                                              approveList[index]
                                                                  .docLId
                                                                  .toString(),
                                                              statuscode,
                                                              token);
                                                  if (response == 200) {
                                                    shareprefs();
                                                    Dialog_Tang()
                                                        .approveSuccessdialog(
                                                            context);
                                                  } else {
                                                    Dialog_Tang()
                                                        .falsedialog(context);
                                                  }
                                                } catch (e) {
                                                  Dialog_Tang()
                                                      .interneterrordialog(
                                                          context);
                                                  log(e.toString());
                                                } finally {
                                                  setState(() {
                                                     shareprefs();
                                                    loading = false;
                                                  });
                                                }
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
          );
  }
}
