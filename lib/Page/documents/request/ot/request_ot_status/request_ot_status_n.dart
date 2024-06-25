import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/ot_Custom_card/request/Custom_card_ot_request.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_ot_status_cancelled extends StatefulWidget {
  const request_ot_status_cancelled({super.key});

  @override
  State<request_ot_status_cancelled> createState() =>
      _request_ot_status_cancelledState();
}

class _request_ot_status_cancelledState
    extends State<request_ot_status_cancelled>
    with AutomaticKeepAliveClientMixin {
  int countLeaveN = 0;
  bool loading = false;
  @override
  void initState() {
    loading = true;
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  // A map to track the expansion state of each tile
  Map<int, bool> _isOpen = {};
  // Simulate a list of items with unknown length
  final List<String> _items = List<String>.generate(100, (i) => "Item $i");
  List<Data> otList = [];

  int indexopen = 0;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    await _get_ot();
  }

  Future _get_ot() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneot = await get_doc_Ot_list_one_Service().model(token, context);
      setState(() {
        otList = getoneot;
        countLeaveN = otList
            .where((_approveList) => _approveList.status == 'cancelled')
            .length;
        debugPrint('getoneot: ${getoneot}');
      });
    } catch (e) {
      log('message');
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: ListView.builder(
                itemCount: otList.length,
                itemBuilder: (context, index) {
                  indexopen = index;
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
                  return indentStatus == 'cancelled'
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
                          enddatetitle: 'OT_request_list.endTime',
                          endDate: '${otList[index].endDate?.split('T').first}',
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
                  
                })),
        loading
            ? LoadingComponent()
            : countLeaveN == 0
                ? information_not_found()
                : SizedBox()
      ],
    );
  }

  _onRefresh() async {
    setState(() {
      loading = true;
    });
    try {
      await Future.delayed(Duration(seconds: 1));
      await _update_isOpenKey();
      await shareprefs();
    } catch (e) {
      setState(() {
        debugPrint('e: ${e}');
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future _update_isOpenKey() async {
    setState(() {
      _isOpen[indexopen] = false;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
