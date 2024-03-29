import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_improve_uptime_status_waiting extends StatefulWidget {
  const request_improve_uptime_status_waiting({super.key});

  @override
  State<request_improve_uptime_status_waiting> createState() => _request_improve_uptime_status_waitingState();
}

class _request_improve_uptime_status_waitingState extends State<request_improve_uptime_status_waiting> {
  int countLeaveW =0;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<Data> add_time_List = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_addtime(token);
  }

  Future _get_addtime(taken) async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave = await get_addtime_list_Service().model(taken);
      setState(() {
        add_time_List = getoneleave;
       countLeaveW = add_time_List
          .where(
              (_approveList) => _approveList.statusApprove == 'waiting')
          .length; 
      });
       
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
    return loading
        ? LoadingComponent():
       countLeaveW == 0
                  ? information_not_found()
                    : ListView.builder(
            itemCount: add_time_List.length,
            itemBuilder: (context, index) {
              var docotApprove = add_time_List[index].docAddtimeApprove;
              String status;
              var indentStatus = add_time_List[index].statusApprove;
              if (indentStatus == 'waiting') {
                status = 'Leaverequestlist.Waiting_for_approval'.tr();
              } else if (indentStatus == 'approved') {
                status = 'Leaverequestlist.Approved'.tr();
              } else {
                status = 'Leaverequestlist.Not_approved'.tr();
              }
              return add_time_List[index].statusApprove == 'waiting'
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
                                          '${add_time_List[index].employeeName}',
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
                                                Text('Request_Improve_Uptime.name').tr(),
                                                Text(
                                                    '${add_time_List[index].employeeName}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Request_Improve_Uptime.create_date')
                                                    .tr(),
                                                Text(
                                                    '${add_time_List[index].createDate?.split('T').first}'),
                                              ],
                                            ),
                                            // Wrap(
                                            //   children: [
                                            //     Text('Leaverequestlist.endTime')
                                            //         .tr(),
                                            //     Text(
                                            //         '${add_time_List[index].endDate!.split('T').first}'),
                                            //   ],
                                            // ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Request_Improve_Uptime.details')
                                                    .tr(),
                                                Text(
                                                    '${add_time_List[index].description}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Request_Improve_Uptime.status')
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
                                            Text('Request_Improve_Uptime.Approval_authority'.tr()),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: docotApprove!.length,
                                                itemBuilder: (context, index) {
                                                  String appoveStatus;
                                                  var appeoveStatus =
                                                      docotApprove[index]
                                                          .status;
                                                  if (appeoveStatus == 'waiting') {
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
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment
                                            //           .spaceBetween,
                                            //   children: [
                                            //     Text('Leaverequestlist.picture')
                                            //         .tr(),
                                            //     IconButton(
                                            //         onPressed: () async {
                                            //           var bytes;
                                            //           var service =
                                            //               get_pic_docService();
                                            //           var response =
                                            //               await service.model(
                                            //                   token,
                                            //                   add_time_List[index]
                                            //                       .docId
                                            //                       .toString());
                                            //           log(response.toString());
                                            //           if (response ==
                                            //               'ไม่พบรูปภาพ') {
                                            //             Snack_Bar(
                                            //                     snackBarColor:
                                            //                         Colors.red,
                                            //                     snackBarIcon: Icons
                                            //                         .warning_rounded,
                                            //                     snackBarText:
                                            //                         'Leaverequestlist.Picture_not_found')
                                            //                 .showSnackBar(
                                            //                     context);
                                            //           } else {
                                            //             bytes = response;
                                            //             return showDialog(
                                            //               context: context,
                                            //               builder: (context) {
                                            //                 return AlertDialog(
                                            //                   title: Container(
                                            //                     width: 200,
                                            //                     height: 200,
                                            //                     child: Image
                                            //                         .network(
                                            //                             bytes),
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             );
                                            //           }
                                            //         },
                                            //         icon: Icon(
                                            //           Icons.image_outlined,
                                            //           size: 40,
                                            //         )),
                                            //   ],
                                            // ),
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
