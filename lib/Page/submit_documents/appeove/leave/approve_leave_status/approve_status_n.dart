import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_appreove_leave/get_appreove_leave.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_leave/approve.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_leave/get_Apporev_leave.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_Not_approved extends StatefulWidget {
  const status_Not_approved({super.key});

  @override
  State<status_Not_approved> createState() => _status_Not_approvedState();
}

class _status_Not_approvedState extends State<status_Not_approved> {
  int countLeaveN = 0;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }
@override
void dispose() {
  
  super.dispose();
}
  List<DocList> approveList = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
   await _get_leave();
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
        var getoneleave = await get_appreove_leave_Service().model(token);
      setState(() {
        approveList = getoneleave;
             countLeaveN = approveList
          .where((_approveList) => _approveList.statusAprrove == 'cancelled')
          .length;
      });
    } catch (e) {
      loading = false;
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
    return loading
        ? LoadingComponent()
        : countLeaveN == 0
            ? information_not_found()
            : ListView.builder(
                itemCount: approveList.length,
                itemBuilder: (context, index) {
                  // var docotApprove = approveList[index].docLeaveApprove;
                  String status;
                  var indentStatus = approveList[index].statusAprrove;
                  if (indentStatus == 'waiting') {
                    status = 'Approve_leave.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Approve_leave.Approved'.tr();
                  } else {
                    status = 'Approve_leave.Not_approved'.tr();
                  }
                  return approveList[index].statusAprrove == 'cancelled'
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
                                                Text('Approve_leave.starttime')
                                                    .tr(),
                                                Text(
                                                    '${approveList[index].createDate?.split('T').first}'),
                                              ],
                                            ),
                                            // Wrap(
                                            //   children: [
                                            //     Text('Approve_leave.endTime')
                                            //         .tr(),
                                            //     Text(
                                            //         '${approveList[index].endDate!.split('T').first}'),
                                            //   ],
                                            // ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Approve_leave.Leavetype')
                                                    .tr(),
                                                Text(
                                                    '${approveList[index].leaveType}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Approve_leave.details')
                                                    .tr(),
                                                Text(
                                                    '${approveList[index].description}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Approve_leave.status')
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
                                            // Text(
                                            //     'Approve_leave.Approval_authority'
                                            //         .tr()),
                                            // ListView.builder(
                                            //     shrinkWrap: true,
                                            //     padding: EdgeInsets.zero,
                                            //     itemCount: docotApprove!.length,
                                            //     itemBuilder: (context, index) {
                                            //       String appoveStatus;
                                            //       var appeoveStatus =
                                            //           docotApprove[index]
                                            //               .status;
                                            //       if (appeoveStatus ==
                                            //           'waiting') {
                                            //         appoveStatus =
                                            //             'Approve_leave.Waiting_for_approval'
                                            //                 .tr();
                                            //       } else if (appeoveStatus ==
                                            //           'approved') {
                                            //         appoveStatus =
                                            //             'Approve_leave.Approved'
                                            //                 .tr();
                                            //       } else {
                                            //         appoveStatus =
                                            //             'Approve_leave.Not_approved'
                                            //                 .tr();
                                            //       }
                                            //       return ListTile(
                                            //         contentPadding:
                                            //             EdgeInsets.zero,
                                            //         dense: true,
                                            //         leading: Text(
                                            //             '${docotApprove[index].employeeName}'),
                                            //         trailing: Text(
                                            //             '${appoveStatus}',
                                            //             style: TextStyle(
                                            //                 color: appeoveStatus ==
                                            //                         'waiting'
                                            //                     ? Colors.amber
                                            //                     : appeoveStatus ==
                                            //                             'approved'
                                            //                         ? Colors
                                            //                             .green
                                            //                         : Colors
                                            //                             .red)),
                                            //       );
                                            //     }),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Approve_leave.picture')
                                                    .tr(),
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
                                      ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                try {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  String statuscode = 'approved';
                                                  var response =
                                                      await Approve_Leave_Service()
                                                          .model(
                                                              approveList[index]
                                                                  .docId
                                                                  .toString(),
                                                              statuscode,
                                                              token);
                                                  if (response == 200) {
                                                    Dialog_approveSuccess
                                                        .showCustomDialog(
                                                            context);
                                                  } else {
                                                    Dialog_false
                                                        .showCustomDialog(
                                                            context);
                                                  }
                                                } catch (e) {
                                                  //Dialog_internetError
                                                   //   .showCustomDialog(
                                                     //     context);
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
                                                  String statuscode =
                                                      'cancelled';
                                                  var response =
                                                      await Approve_Leave_Service()
                                                          .model(
                                                              approveList[index]
                                                                  .docId
                                                                  .toString(),
                                                              statuscode,
                                                              token);
                                                  if (response == 200) {
                                                    // shareprefs();
                                                    // Dialog_approveSuccess
                                                    //     .showCustomDialog(
                                                    //         context);
                                                            showDialog(context: context, builder: (context) => Dialog_approveSuccess(),);
                                                  } else {
                                                    Dialog_false
                                                        .showCustomDialog(
                                                            context);
                                                  }
                                                } catch (e) {
                                                  //Dialog_internetError
                                                   //   .showCustomDialog(
                                                     //     context);
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
                });
  }
}
