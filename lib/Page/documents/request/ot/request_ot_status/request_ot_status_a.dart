import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/ot_Custom_card/request/Custom_card_ot_request.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_ot_status_Approved extends StatefulWidget {
  const request_ot_status_Approved({super.key});

  @override
  State<request_ot_status_Approved> createState() =>
      _request_ot_status_ApprovedState();
}

class _request_ot_status_ApprovedState extends State<request_ot_status_Approved>
    with AutomaticKeepAliveClientMixin {
  int countLeaveW = 0;
  bool loading = false;
  List<Data> otList = [];
  @override
  void initState() {
    loading = true;
    shareprefs();
    // TODO: implement initState
    // super.initState();
  }

  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    await _get_ot(token);
  }

  Future _get_ot(_gettoken) async {
    try {
      setState(() {
        loading = true;
      });
      var getoneot =
          await get_doc_Ot_list_one_Service().model(_gettoken, context);
      otList = getoneot;
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        countLeaveW = otList
            .where((_approveList) => _approveList.status == 'approved')
            .length;
      });
    } catch (e) {
      log(e.toString());
      loading = false;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : countLeaveW == 0
            ? information_not_found()
            : ListView.builder(
                itemCount: otList.length,
                itemBuilder: (context, index) {
                  List<DocApprove> docotApprove =
                      otList[index].docApprove ?? [];
                  String status;
                  var indentStatus = otList[index].status;
                  if (indentStatus == 'waiting') {
                    status = 'OT_request_list.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'OT_request_list.Approved'.tr();
                  } else {
                    status = 'OT_request_list.cancelled'.tr();
                  }
                  return indentStatus == 'approved'
                      ? Custom_card_ot(
                          isOpentalling: false,
                          isOpenButtons: false,
                          isTextbuttons: false,
                          employeetitle: 'OT_request_list.name',
                          employeename: '${otList[index].employee?.firstName} ${otList[index].employee?.lastName}',
                          status: status,
                          indentStatus: '$indentStatus',
                          starttimetitle: 'OT_request_list.starttime',
                          startdate: '${otList[index].startDate?.split('T').first}',
                          enddatetitle: '${otList[index].endDate!.split('T').first}',
                          endDate: '${otList[index].endDate!.split('T').first}',
                          ottitle: 'OT_request_list.OTtype',
                          otType: '${otList[index].ot?.otName}',
                          detailtitle: 'OT_request_list.details',
                          detail: '${otList[index].description}',
                          listApprov: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: docotApprove.length,
                              itemBuilder: (context, index) {
                                String appoveStatus;
                                var appeoveStatus = docotApprove[index].status;
                                if (appeoveStatus == 'waiting') {
                                  appoveStatus =
                                      'OT_request_list.Waiting_for_approval'
                                          .tr();
                                } else if (appeoveStatus == 'approved') {
                                  appoveStatus =
                                      'OT_request_list.Approved'.tr();
                                } else {
                                  appoveStatus =
                                      'OT_request_list.cancelled'.tr();
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
