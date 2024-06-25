import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/uptime_Custom_card/request/Custom_card_uptime_request.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_improve_uptime_status_cancelled extends StatefulWidget {
  const request_improve_uptime_status_cancelled({super.key});

  @override
  State<request_improve_uptime_status_cancelled> createState() =>
      _request_improve_uptime_status_cancelledState();
}

class _request_improve_uptime_status_cancelledState
    extends State<request_improve_uptime_status_cancelled>
    with AutomaticKeepAliveClientMixin {
  int countLeaveW = 0;
  @override
  void initState() {
    loading = true;
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
    //await get_Device_token_service().model(token);
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
            .where((_approveList) => _approveList.status == 'cancelled')
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
        : countLeaveW == 0
            ? information_not_found()
            : ListView.builder(
                itemCount: add_time_List.length,
                itemBuilder: (context, index) {
                  String createdate =
                      dateparse(add_time_List[index].createAt.toString());
                  String createtime =
                      timeparse(add_time_List[index].createAt.toString());
                  List<DocApprove> docotApprove =
                      add_time_List[index].docApprove ?? [];
                  String status;
                  var indentStatus = add_time_List[index].status;
                  if (indentStatus == 'waiting') {
                    status = 'Leaverequestlist.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Leaverequestlist.Approved'.tr();
                  } else {
                    status = 'Leaverequestlist.cancelled'.tr();
                  }
                  return add_time_List[index].status == 'cancelled'
                      ? Custom_card_uptime_request(
                          isOpentalling: false,
                          isOpenButtons: false,
                          isTextbuttons: false,
                          employeetitle: 'Request_Improve_Uptime.name',
                          employeename:
                              '${add_time_List[index].employee?.firstName} ${add_time_List[index].employee?.lastName}',
                          status: status,
                          indentStatus: '$indentStatus',
                          createAttitle: 'Request_Improve_Uptime.create_date',
                          createAt: '$createdate $createtime',
                          shiptitle: 'Request_Improve_Uptime.shipdate',
                          shipdate: '${add_time_List[index].shiftDate}',
                          detailtitle: 'Request_Improve_Uptime.details',
                          detail: '${add_time_List[index].description}',
                          listApprov: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: docotApprove.length,
                              itemBuilder: (context, index) {
                                String appoveStatus;
                                var appeoveStatus = docotApprove[index].status;
                                if (appeoveStatus == 'waiting') {
                                  appoveStatus =
                                      'Leaverequestlist.Waiting_for_approval'
                                          .tr();
                                } else if (appeoveStatus == 'approved') {
                                  appoveStatus =
                                      'Leaverequestlist.Approved'.tr();
                                } else {
                                  appoveStatus =
                                      'Leaverequestlist.cancelled'.tr();
                                }
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                   minTileHeight: 25,
                                  dense: true,
                                  leading: Text(
                                      '${docotApprove[index].employeeName}'),
                                  trailing: Text('${appoveStatus}',
                                      style: TextStyle(
                                          color: appeoveStatus == 'waiting'
                                              ? Colors.amber
                                              : appeoveStatus == 'approved'
                                                  ? Colors.green
                                                  : Colors.red)),
                                );
                              }),
                          onChang: (value) {},
                          onEdite: () {},
                          onCancel: () {},
                          editeButtons: () {},
                          cancelButtons: () {},
                        )
                      : SizedBox();
                });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
