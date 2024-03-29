import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_ot_status_waiting extends StatefulWidget {
  const request_ot_status_waiting({super.key});

  @override
  State<request_ot_status_waiting> createState() => _request_ot_status_waitingState();
}

class _request_ot_status_waitingState extends State<request_ot_status_waiting> {
  int countLeaveW =0;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<Data> otList = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_ot(token);
  }

  Future _get_ot(tokn) async {
    // try {
      setState(() {
        loading = true;
      });
      var getoneot = await get_doc_Ot_list_one_Service().model(tokn);
      otList = getoneot;
      setState(() {
       countLeaveW = otList
          .where(
              (_otList) => _otList.statusApprove == 'waiting')
          .length; 
          loading = false;
          log(countLeaveW.toString());
      });
       
    // } catch (e) {
    //   log(e.toString());
    // } finally {
    //   setState(() {
    //     loading = false;
    //   });
    // }
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
            itemCount: otList.length,
            itemBuilder: (context, index) {
              var docotApprove = otList[index].docOtApprove;
              String status;
              var indentStatus = otList[index].statusApprove;
              if (indentStatus == 'waiting') {
                status = 'OT_request_list.Waiting_for_approval'.tr();
              } else if (indentStatus == 'approved') {
                status = 'OT_request_list.Approved'.tr();
              } else {
                status = 'OT_request_list.Not_approved'.tr();
              }
              return otList[index].statusApprove == 'waiting'
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
                                          '${otList[index].employeeName}',
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
                                                Text('OT_request_list.name').tr(),
                                                Text(
                                                    '${otList[index].employeeName}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.starttime')
                                                    .tr(),
                                                Text(
                                                    '${otList[index].startDate}'),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.endTime')
                                                    .tr(),
                                                Text(
                                                    '${otList[index].endDate}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.OTtype')
                                                    .tr(),
                                                Text(
                                                    '${otList[index].otType}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.details')
                                                    .tr(),
                                                Text(
                                                    '${otList[index].description == null || otList[index].description!.isEmpty ? 'ไม่พบข้อมูล' : otList[index].description}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.status')
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
                                            Text('OT_request_list.Approval_authority'.tr()),
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
                                                        'OT_request_list.Waiting_for_approval'
                                                            .tr();
                                                  } else if (appeoveStatus ==
                                                      'approved') {
                                                    appoveStatus =
                                                        'OT_request_list.Approved'
                                                            .tr();
                                                  } else {
                                                    appoveStatus =
                                                        'OT_request_list.Not_approved'
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
