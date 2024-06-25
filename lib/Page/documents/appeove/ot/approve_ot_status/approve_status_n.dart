import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_appreove_Ot_Model/get_appreove_Ot_Model.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_ot/approve_ot.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_ot_list/get_ot_list.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_cancelled_ot extends StatefulWidget {
  const status_cancelled_ot({super.key});

  @override
  State<status_cancelled_ot> createState() => _status_cancelled_otState();
}

class _status_cancelled_otState extends State<status_cancelled_ot>  with AutomaticKeepAliveClientMixin{
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
                _docList.statusApprove == 'cancelled')
            .length;
            log(countotN.toString());
      });
      
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
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
              String status;
              var indentStatus = docList[index].statusApprove;
              if (indentStatus == 'waiting') {
                status = 'OT_request_list.Waiting_for_approval'.tr();
              } else if (indentStatus == 'approved') {
                status = 'OT_request_list.Approved'.tr();
              } else {
                status = 'OT_request_list.cancelled'.tr();
              }
              return docList[index].statusApprove == 'cancelled'
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Icon(Bootstrap.calendar_event,color: Theme.of(context).primaryColor,),
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
                                            
                                            Divider(),
                                          ],
                                        ),
                                      ), ButtonOneAppprove(
                                              onPressBtSucess: () async {
    var re;
                                                  String statuscode = 'approved';
                                                  var response =
                                                      await Approve_ot_Service()
                                                          .model(
                                                              docList[index]
                                                                  .docId
                                                                  .toString(),
                                                              statuscode,
                                                              token).then((result) {
                                                    log('cancelled: ${result}');
                                                   
                                                    if (result == 200) {
                                                    Dialog_Success.showCustomDialog(context);
                                                  } else {
                                                    var data = result.toString();
                                                     re = data.split(':').last.split('}').first;
                                                    Dialog_Error_responseStatus.showCustomDialog(context, '$re');
                                                  }
                                                  });
                                                  
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
            }):information_not_found();
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
