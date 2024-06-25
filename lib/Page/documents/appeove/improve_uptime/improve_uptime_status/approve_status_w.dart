import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/approve_addtime_model.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_aadtime/approve_addtime_service.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_waiting_improve_uptime extends StatefulWidget {
  const status_waiting_improve_uptime({super.key});

  @override
  State<status_waiting_improve_uptime> createState() =>
      _status_waiting_improve_uptimeState();
}

class _status_waiting_improve_uptimeState
    extends State<status_waiting_improve_uptime>
    with AutomaticKeepAliveClientMixin {
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
            .where((addtime) => addtime.statusApprove == 'waiting')
            .length;
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

  Future approve_addtime(add_time_id, status) async {
    var re;
    var service = approve_addtime_service();
    var response =
        service.approve_addtime(add_time_id, status, token).then((result) {
      if (result == 200) {
        Dialog_Success.showCustomDialog(context);
      } else {
        var data = result.toString();
        re = data.split(':').last.split('}').first;
        Dialog_Error_responseStatus.showCustomDialog(context, '$re');
      }
    });
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
        ? LoadingComponent()
        : countotW != 0
            ? ListView.builder(
                itemCount: _addtime.length,
                itemBuilder: (context, index) {
                  String status;
                  var indentStatus = _addtime[index].statusApprove;
                  if (indentStatus == 'waiting') {
                    status = 'OT_request_list.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'OT_request_list.Approved'.tr();
                  } else {
                    status = 'OT_request_list.Not_approved'.tr();
                  }
                  return _addtime[index].statusApprove == 'waiting'
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
                                            
                                            Divider(),
                                          ],
                                        ),
                                      ),
                                      ButtonTwoAppprove(
                                        onPressBtSucess: () async {
                                          String statuscode = 'approved';
                                          var response = await approve_addtime(
                                            _addtime[index].docId.toString(),
                                            statuscode,
                                          );
                                        },
                                        onPressBtNotsuc: () async {
                                          String statuscode = 'cancelled';
                                          var response = await approve_addtime(
                                              _addtime[index].docId.toString(),
                                              statuscode);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
