import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/approve_addtime_model.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_Approved_improve_uptime extends StatefulWidget {
  const status_Approved_improve_uptime({super.key});

  @override
  State<status_Approved_improve_uptime> createState() =>
      _status_Approved_improve_uptimeState();
}

class _status_Approved_improve_uptimeState
    extends State<status_Approved_improve_uptime>  with AutomaticKeepAliveClientMixin{
  int countotA = 0;
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
          countotA = _addtime
            .where((addtime) =>
                addtime.statusApprove == 'approved')
            .length;
            log(countotA.toString());
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
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (mounted) {

    } else {
      
    }
  }
  Future approve_addtime(add_time_id, status) async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/approve_addtime';
      var response = await Dio().post(url,
          data: {"add_time_id": "$add_time_id", "status": '$status'},
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
        : countotA != 0
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
                    status = 'OT_request_list.cancelled'.tr();
                  }
                  return indentStatus == 'approved'
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
                                           
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Apporv_Improve_Uptime.date')
                                                    .tr(),
                                                Text(
                                                    '${_addtime[index].shiftDate}'),
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
