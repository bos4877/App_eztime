import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_appreove_Ot_Model/get_appreove_Ot_Model.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_ot/approve_ot.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_ot_list/get_ot_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_Not_approved_ot extends StatefulWidget {
  const status_Not_approved_ot({super.key});

  @override
  State<status_Not_approved_ot> createState() => _status_Not_approved_otState();
}

class _status_Not_approved_otState extends State<status_Not_approved_ot> {
  int countotN = 0;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<DocList> docList = [];
  bool loading = false;
  var token;
 Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _get_ot();
  }

  Future _get_ot() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneOt = await get_appreove_Ot_Service().model(token);
      setState(() {
        docList = getoneOt;
          countotN = docList
            .where((_docList) =>
                _docList.statusAprrove == 'cancelled')
            .length;
            log(countotN.toString());
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
       countotN != 0
                  ? 
                    ListView.builder(
            itemCount: docList.length,
            itemBuilder: (context, index) {
              // var docotApprove = docList[index].docOtApprove;
              String status;
              var indentStatus = docList[index].statusAprrove;
              if (indentStatus == 'waiting') {
                status = 'OT_request_list.Waiting_for_approval'.tr();
              } else if (indentStatus == 'approved') {
                status = 'OT_request_list.Approved'.tr();
              } else {
                status = 'OT_request_list.Not_approved'.tr();
              }
              return docList[index].statusAprrove == 'cancelled'
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
                                                    '${docList[index].employeeName}'),
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
                                                    '${docList[index].createDate?.split('T').first}'),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Text('OT_request_list.endTime')
                                                    .tr(),
                                                Text(
                                                    '${docList[index].shiftDate?.split('T').first}'),
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
                                                    '${docList[index].otType}'),
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
                                                    '${docList[index].description}'),
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
                                            // Text('OT_request_list.Approval_authority'.tr()),
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
                                            //             'OT_request_list.Waiting_for_approval'
                                            //                 .tr();
                                            //       } else if (appeoveStatus ==
                                            //           'approved') {
                                            //         appoveStatus =
                                            //             'OT_request_list.Approved'
                                            //                 .tr();
                                            //       } else {
                                            //         appoveStatus =
                                            //             'OT_request_list.Not_approved'
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
                                      ), ButtonTwoAppprove(
                                              onPressBtSucess: () async {
                                                try {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  String statuscode = 'approved';
                                                  var response =
                                                      await Approve_ot_Service()
                                                          .model(
                                                              docList[index]
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
                                                  String statuscode = 'cancelled';
                                                  var response =
                                                      await Approve_ot_Service()
                                                          .model(
                                                              docList[index]
                                                                  .docId
                                                                  .toString(),
                                                              statuscode,
                                                              token);
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
            }):Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 150,
                      color: Colors.white,
                        child: Text('ไม่พบข้อมูล'),
                      ),
                  );
  }
}
