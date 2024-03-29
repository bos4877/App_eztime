import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_leave/approve.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_leave_page extends StatefulWidget {
  const Request_leave_page({super.key});

  @override
  State<Request_leave_page> createState() => _Request_leave_pageState();
}

class _Request_leave_pageState extends State<Request_leave_page> {
  bool loading = false;
  String? emyApprove_status2;
  List<Data> docList = [];
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
     await get_leave();
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
       setState(() {
        loading = false;
      });
    } catch (e) {
      log(e.toString());
       setState(() {
        loading = false;
      });
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
      var response = Approve_Leave_Service().model(id, status, tokenD);
      if (response == 200) {
        Dialog_save_Success.showCustomDialog(context);
      } else {
        Dialog_false.showCustomDialog(context);
      }
       setState(() {
        loading = false;
      });
    } catch (e) {
      //Dialog_internetError.showCustomDialog(context);
      log(e.toString());
       setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  onRefresh()async{
setState(() {
  loading = true;
});
await  SharedPrefs();
setState(() {
  loading = false;
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Leaverequestlist.title').tr(),
            ),
            body: loading
        ? LoadingComponent()
        :  ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  String status;
                  var docLeaveApprove = docList[index].docLeaveApprove;
                  var indentStatus = docList[index].statusAprrove;
                  log('${indentStatus}');
                  if (indentStatus == 'waiting') {
                    status = 'Leaverequestlist.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Leaverequestlist.Approved'.tr();
                  } else {
                    status = 'Leaverequestlist.Not_approved'.tr();
                  }
                  return RefreshIndicator(
                    onRefresh: () =>onRefresh(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Theme.of(context).primaryColor)),
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
                                      '${docList[index].employeeName}',
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
                                            Text('Leaverequestlist.name').tr(),
                                            Text(
                                                ' ${docList[index].employeeName}'),
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
                                                ' ${docList[index].startDate!.split('T').first}'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text('Leaverequestlist.endTime').tr(),
                                            Text(
                                                ' ${docList[index].endDate!.split('T').first}'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text('Leaverequestlist.Leavetype')
                                                .tr(),
                                            Text(
                                                ' ${docList[index].leaveType}'),
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
                                                    color: indentStatus == 'waiting'
                                                        ? Colors.amber
                                                        : indentStatus == 'approved'
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
                                                              .docId
                                                              .toString());
                                                  log(response.toString());
                                                  if (response == 'ไม่พบรูปภาพ') {
                                                    Snack_Bar(
                                                            snackBarColor:
                                                                Colors.red,
                                                            snackBarIcon: Icons
                                                                .warning_rounded,
                                                            snackBarText:
                                                                'Leaverequestlist.Picture_not_found')
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
                                        Text('Leaverequestlist.Person_With_Approval')
                                            .tr(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: docLeaveApprove!.length,
                                            itemBuilder: (context, index) {
                                              String appoveStatus;
                                              
                                              var appeoveStatus =
                                                  docLeaveApprove[index].status;
                                                  emyApprove_status2 = appeoveStatus!;
                                              if (appeoveStatus == 'waiting') {
                                                appoveStatus = 'Approve_leave.Waiting_for_approval'.tr();
                                                emyApprove_status2 = "waiting";
                                              } else if (appeoveStatus == 'approved') {
                                                appoveStatus = 'Approve_leave.Approved'.tr();
                                                emyApprove_status2 = "approved";
                                              } else {
                                                emyApprove_status2 = "cancelled";
                                                appoveStatus = 'Approve_leave.Not_approved'.tr();
                                              }
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                leading: Text(
                                                    '${docLeaveApprove[index].employeeName}'),
                                                trailing: Text('$appoveStatus',
                                                    style: TextStyle(
                                                        color: appeoveStatus ==
                                                                'waiting'
                                                            ? Colors.amber
                                                            : appeoveStatus == 'approved'
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
                                        showDialog(
                                          barrierDismissible: false,
                                          barrierColor: Colors.white,
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Center(
                                              child: Text(
                                                'Notification.title',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red),
                                              ).tr(),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  delect_doc(
                                                docList[index].docId.toString(),
                                                status,
                                                token);
                                                },
                                                child: Text('save',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                              SizedBox(width: 5),
                                              TextButton(
                                                onPressed: () {
                                                  ; // Close the dialog
                                                },
                                                child: Text('Close',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                            content: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'ต้องการยกลิกใช่หรือไม่',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
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
                        ]),
                  );
                }));
  }
}
