import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/leave/Images_doc_Model/Images_doc_Model.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_leave_status_waiting extends StatefulWidget {
  const request_leave_status_waiting({super.key});

  @override
  State<request_leave_status_waiting> createState() =>
      _request_leave_status_waitingState();
}

class _request_leave_status_waitingState
    extends State<request_leave_status_waiting> {
  int countLeaveW = 0;
  Images_doc_Model_leavelist dataimages = Images_doc_Model_leavelist(); 
  String _imagesleave = '';
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<Data> leaveList = [];
  bool loading = false;
  var token;
  Future shareprefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_leave();

  }

  _get_images(docid) async {
    setState(() {
      loading = true;
    });
    var get_images = await get_pic_docService().model(token, docid);
    setState(() {
       _imagesleave = get_images;
      //  _imagesleave = dataimages.img!;
      loading = false;
    });
    
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave = await get_DocOne_Service().model(token);
      setState(() {
        leaveList = getoneleave;
        countLeaveW = leaveList
            .where((_approveList) => _approveList.statusAprrove == 'waiting')
            .length;
        loading = false;
      });
    } catch (e) {
      log(e.toString());
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
      //Dialog_internetError.showCustomDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : countLeaveW == 0
            ? Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 150,
                  color: Colors.white,
                  child: Text('ไม่พบข้อมูล'),
                ),
              )
            : loading
        ? LoadingComponent()
        : ListView.builder(
                itemCount: leaveList.length,
                itemBuilder: (context, index) {
                  var docotApprove = leaveList[index].docLeaveApprove;
                  String status;
                  var indentStatus = leaveList[index].statusAprrove;
                  if (indentStatus == 'waiting') {
                    status = 'Leaverequestlist.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Leaverequestlist.Approved'.tr();
                  } else {
                    status = 'Leaverequestlist.Not_approved'.tr();
                  }
                  return leaveList[index].statusAprrove == 'waiting'
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
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
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
                                          '${leaveList[index].employeeName}',
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
                                                color: indentStatus == 'waiting'
                                                    ? Colors.amber
                                                    : indentStatus == 'approved'
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
                                                Text('Leaverequestlist.name')
                                                    .tr(),
                                                Text(
                                                    '${leaveList[index].employeeName}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Leaverequestlist.starttime')
                                                    .tr(),
                                                Text(
                                                    '${leaveList[index].startDate!.split('T').first}'),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Leaverequestlist.endTime')
                                                    .tr(),
                                                Text(
                                                    '${leaveList[index].endDate!.split('T').first}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Leaverequestlist.Leavetype')
                                                    .tr(),
                                                Text(
                                                    '${leaveList[index].leaveType}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Leaverequestlist.details')
                                                    .tr(),
                                                Text(
                                                    '${leaveList[index].description}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Leaverequestlist.status')
                                                    .tr(),
                                                Text(' $status',
                                                    style: TextStyle(
                                                        color: indentStatus ==
                                                                'waiting'
                                                            ? Colors.amber
                                                            : indentStatus ==
                                                                    'approved'
                                                                ? Colors.green
                                                                : Colors.red)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'Leaverequestlist.Approval_authority'
                                                    .tr()),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: docotApprove!.length,
                                                itemBuilder: (context, index) {
                                                  String appoveStatus;
                                                  var appeoveStatus =
                                                      docotApprove[index]
                                                          .status;
                                                  if (appeoveStatus ==
                                                      'waiting') {
                                                    appoveStatus =
                                                        'Leaverequestlist.Waiting_for_approval'
                                                            .tr();
                                                  } else if (appeoveStatus ==
                                                      'approved') {
                                                    appoveStatus =
                                                        'Leaverequestlist.Approved'
                                                            .tr();
                                                  } else {
                                                    appoveStatus =
                                                        'Leaverequestlist.Not_approved'
                                                            .tr();
                                                  }
                                                  return ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    dense: true,
                                                    leading: Text(
                                                        '${docotApprove[index].employeeName}'),
                                                    trailing: Text(
                                                        '${appoveStatus}',
                                                        style: TextStyle(
                                                            color: appeoveStatus ==
                                                                    'waiting'
                                                                ? Colors.amber
                                                                : appeoveStatus ==
                                                                        'approved'
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
                                                Text('Leaverequestlist.picture')
                                                    .tr(),
                                                IconButton(
                                                    onPressed: () async {
                                                      var bytes;
                                                      var service =
                                                          get_pic_docService();
                                                      var response =
                                                          await service.model(
                                                              token,
                                                              leaveList[index]
                                                                  .docId
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
                                                                    'Leaverequestlist.Picture_not_found')
                                                            .showSnackBar(
                                                                context);
                                                      } else {
                                                        _get_images(leaveList[index]
                                                                  .docId);

                                                        return showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return loading ? LoadingComponent() : AlertDialog(
                                                              title: Container(
                                                                width: 200,
                                                                height: 200,
                                                                child: Image
                                                                    .network(
                                                                        '${_imagesleave}',),
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
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ])
                      : Container();
                });
  }
}
