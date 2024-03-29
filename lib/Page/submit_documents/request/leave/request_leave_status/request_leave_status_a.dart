import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class request_leave_status_Approved extends StatefulWidget {
  const request_leave_status_Approved({super.key});

  @override
  State<request_leave_status_Approved> createState() => _request_leave_status_ApprovedState();
}

class _request_leave_status_ApprovedState extends State<request_leave_status_Approved> {
    @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<Data> approveList = [];
  bool loading = false;
  int countLeaveA = 0;
  int countStatusA = 0;
  int appeoveCountdoc = 0;
  var token;
  Future shareprefs() async {
      setState(() {
        loading = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_leave();
     setState(() {
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
        approveList = getoneleave;
        appeoveCountdoc = approveList.length;
            countLeaveA = approveList
          .where(
              (_approveList) => _approveList.docLeaveApprove![0].status == 'approved')
          .length; 
          countStatusA = approveList.where((element) => element.statusAprrove == 'approved').length;
      });
      log(appeoveCountdoc.toString());
      log(countStatusA.toString());
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
      //Dialog_internetError.showCustomDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingComponent() :countLeaveA != 0 && countStatusA != 0 ?
    ListView.builder(
                itemCount: approveList.length,
                itemBuilder: (context, index) {
                  var docotApprove = approveList[index].docLeaveApprove;
                  String status;
                  var indentStatus = approveList[index].statusAprrove;
                  if (indentStatus == 'waiting') {
                    status = 'Approve_leave.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Approve_leave.Approved'.tr();
                  } else {
                    status = 'Approve_leave.Not_approved'.tr();
                  }
                  return approveList[index].statusAprrove == 'approved' &&
                          docotApprove![0].status == 'approved'
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
                                          '${approveList[index].employeeName}',
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
                                                Text('Approve_leave.name').tr(),
                                                Text(
                                                    '${approveList[index].employeeName}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                                  Wrap(
                                          children: [
                                            Text('Approve_leave.starttime').tr(),
                                            Text(
                                                '${approveList[index].startDate!.split('T').first}'),
                                          ],
                                        ),
                              Wrap(
                                          children: [
                                            Text('Approve_leave.endTime').tr(),
                                            Text(
                                                '${approveList[index].endDate!.split("T").first}'),
                                          ],
                                        ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                          children: [
                                            Text('Approve_leave.Leavetype').tr(),
                                            Text(
                                                '${approveList[index].leaveType}'),
                                          ],
                                        ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                               Wrap(
                                          children: [
                                            Text('Approve_leave.details').tr(),
                                            Text(
                                                '${approveList[index].description}'),
                                          ],
                                        ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Approve_leave.status').tr(),
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
                                            Text('Leaverequestlist.Approval_authority'.tr()),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: docotApprove.length,
                                                itemBuilder: (context, index) {
                                                  String appoveStatus;
                                                  var appeoveStatus =
                                                      docotApprove[index]
                                                          .status;
                                                  if (appeoveStatus == 'waiting') {
                                                    appoveStatus = 'Approve_leave.Waiting_for_approval'.tr();
                                                  } else if (appeoveStatus ==
                                                      'approved') {
                                                    appoveStatus =
                                                        'Approve_leave.Approved'.tr();
                                                  } else {
                                                    appoveStatus = 'Approve_leave.Not_approved'.tr();
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
                                                Text('Approve_leave.picture').tr(),
                                                IconButton(
                                                    onPressed: () async {
                                                      var bytes;
                                                      var service =
                                                          get_pic_docService();
                                                      var response =
                                                          await service.model(
                                                              token,
                                                              approveList[index]
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
                                                                    'Approve_leave.Picture_not_found')
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
                                      // approveList[index].statusAprrove == 'approved' ||
                                      //         approveList[index].statusAprrove == 'cancelled'
                                      //     ? Container()
                                      //     : ButtonTwoAppprove(
                                      //         onPressBtSucess: () async {
                                      //           try {
                                      //             setState(() {
                                      //               loading = true;
                                      //             });
                                      //             String statuscode = 'A';
                                      //             var response =
                                      //                 await Approve_Leave_Service()
                                      //                     .model(
                                      //                         approveList[index]
                                      //                             .docId
                                      //                             .toString(),
                                      //                         statuscode,
                                      //                         token);
                                      //             if (response == 200) {
                                      //               Dialog_approveSuccess
                                      //                   .showCustomDialog(
                                      //                       context);
                                      //             } else {
                                      //               Dialog_false
                                      //                   .showCustomDialog(
                                      //                       context);
                                      //             }
                                      //           } catch (e) {
                                      //             //Dialog_internetError
                                      //              //   .showCustomDialog(
                                      //                //     context);
                                      //             log(e.toString());
                                      //           } finally {
                                      //             setState(() {
                                      //               shareprefs();
                                      //               loading = false;
                                      //             });
                                      //           }
                                      //         },
                                      //         onPressBtNotsuc: () async {
                                      //           try {
                                      //             setState(() {
                                      //               loading = true;
                                      //             });
                                      //             String statuscode = 'N';
                                      //             var response =
                                      //                 await Approve_Leave_Service()
                                      //                     .model(
                                      //                         approveList[index]
                                      //                             .docId
                                      //                             .toString(),
                                      //                         statuscode,
                                      //                         token);
                                      //             if (response == 200) {
                                      //               shareprefs();
                                      //               Dialog_approveSuccess
                                      //                   .showCustomDialog(
                                      //                       context);
                                      //             } else {
                                      //               Dialog_false
                                      //                   .showCustomDialog(
                                      //                       context);
                                      //             }
                                      //           } catch (e) {
                                      //             //Dialog_internetError
                                      //              //   .showCustomDialog(
                                      //                //     context);
                                      //             log(e.toString());
                                      //           } finally {
                                      //             setState(() {
                                      //               shareprefs();
                                      //               loading = false;
                                      //             });
                                      //           }
                                      //         },
                                      //       ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ])
                      : Container();
                }): Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 150,
                      color: Colors.white,
                        child: Text('ไม่พบข้อมูล'),
                      ),
                  ) ;
  }
}