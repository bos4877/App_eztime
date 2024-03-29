import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/approve_addtime_model.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_waiting_improve_uptime extends StatefulWidget {
  const status_waiting_improve_uptime({super.key});

  @override
  State<status_waiting_improve_uptime> createState() =>
      _status_waiting_improve_uptimeState();
}

class _status_waiting_improve_uptimeState
    extends State<status_waiting_improve_uptime> {
  int countotW = 0;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<DocList> _addtime = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await get_addtime();
  }

  Future get_addtime() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await get_approve_addtime_list_Service().model(token);
      
           setState(() {
       _addtime = response;
          countotW = _addtime
            .where((addtime) =>
                addtime.statusAprrove == 'waiting')
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

  Future approve_addtime(add_time_id, status) async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/approve_Shift';
      var response = await Dio().post(url,
          data: {"doc_id": "$add_time_id", "status": '$status'},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        Dialog_approveSuccess.showCustomDialog(context);
      } else {
        Dialog_false.showCustomDialog(context);
      }
    } catch (e) {
      Dialog_false.showCustomDialog(context);
      log(e.toString());
    } finally {
      setState(() {
        shareprefs();
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
        : countotW != 0
            ? ListView.builder(
                itemCount: _addtime.length,
                itemBuilder: (context, index) {
                  // var docotApprove = _addtime[index].docAddtimeApprove;
                  String status;
                  var indentStatus = _addtime[index].statusAprrove;
                  if (indentStatus == 'waiting') {
                    status = 'OT_request_list.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'OT_request_list.Approved'.tr();
                  } else {
                    status = 'OT_request_list.Not_approved'.tr();
                  }
                  return _addtime[index].statusAprrove == 'waiting'
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
                                          '${_addtime[index].employeeName}',
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
                                                Text('Apporv_Improve_Uptime.Name')
                                                    .tr(),
                                                Text(
                                                    '${_addtime[index].employeeName}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Apporv_Improve_Uptime.creat')
                                                    .tr(),
                                                Text(
                                                    '${_addtime[index].createDate?.split('T').first}'),
                                              ],
                                            ),
                                            //  Wrap(
                                            //   children: [
                                            //     Text('ชื่อกะ: ')
                                            //         .tr(),
                                            //     Text(
                                            //         '${_addtime[index].shiftDate?.split('T').first}'),
                                            //   ],
                                            // ),
                                            Wrap(
                                              children: [
                                                Text('Apporv_Improve_Uptime.date')
                                                    .tr(),
                                                Text(
                                                    '${_addtime[index].shiftDate?.split('T').first}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Apporv_Improve_Uptime.detail')
                                                    .tr(),
                                                Text(
                                                    '${_addtime[index].description}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Apporv_Improve_Uptime.status')
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
                                            // Text('Apporv_Improve_Uptime.Approval_authority'.tr()),
                                            // ListView.builder(
                                            //     shrinkWrap: true,
                                            //     padding: EdgeInsets.zero,
                                            //     itemCount: docotApprove.length,
                                            //     itemBuilder: (context, index) {
                                            //       String appoveStatus;
                                            //       var appeoveStatus =
                                            //           docotApprove[index]
                                            //               .status;
                                            //       if (appeoveStatus == 'waiting') {
                                            //         appoveStatus =
                                            //             'Apporv_Improve_Uptime.Waiting_for_approval'
                                            //                 .tr();
                                            //       } else if (appeoveStatus ==
                                            //           'approved') {
                                            //         appoveStatus =
                                            //             'Apporv_Improve_Uptime.Approved'
                                            //                 .tr();
                                            //       } else {
                                            //         appoveStatus =
                                            //             'Apporv_Improve_Uptime.Not_approved'
                                            //                 .tr();
                                            //       }
                                            //       return ListTile(
                                            //         contentPadding:
                                            //             EdgeInsets.zero,
                                            //         dense: true,
                                            //         leading: Text(
                                            //             '${docotApprove[index].approveFname} ${docotApprove[index].approveLname}'),
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
                                            Divider(),
                                          ],
                                        ),
                                      ),ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                try {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  String statuscode = 'approved';
                                                  var response =
                                                      await approve_addtime(
                                                    _addtime[index]
                                                        .docId
                                                        .toString(),
                                                    statuscode,
                                                  );
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
                                                  String statuscode = 'N';
                                                  var response =
                                                      await approve_addtime(
                                                          _addtime[index]
                                                              .docId
                                                              .toString(),
                                                          statuscode);
                                                  if (response == 200) {
                                                    shareprefs();
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
                })
            : information_not_found();
  }
}
