import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/uptime_Custom_card/request/Custom_card_uptime_request.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart';
import 'package:eztime_app/Page/documents/request/improve_uptime/Edite_improve_uptime/Edite_improve_uptime_page.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_improve_uptime_status_waiting extends StatefulWidget {
  const request_improve_uptime_status_waiting({super.key});

  @override
  State<request_improve_uptime_status_waiting> createState() =>
      _request_improve_uptime_status_waitingState();
}

class _request_improve_uptime_status_waitingState
    extends State<request_improve_uptime_status_waiting>
    with AutomaticKeepAliveClientMixin {
  int countLeaveW = 0;
  int indexopen = 0;
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
  List<Data> add_time_List = [];
  bool loading = false;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    _get_addtime(token);
  }

  Future _get_addtime(token) async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave = await get_addtime_list_Service().model(token);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        add_time_List = getoneleave;
        countLeaveW = add_time_List
            .where((_approveList) => _approveList.status == 'waiting')
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

  Future edit_addTime(String docid, String des, String ship) async {
    try {
      String url = '${connect_api().domain}/edit_Doc_Addtime_details_user';
      var response = await Dio().post(url,
          data: {
            {"doc_id": docid, "description": des, "shift_date": ship},
          },
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        Dialog_Success.showCustomDialog(context);
      } else {}
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  Future cancel_adtime(String docid) async {
    try {
      String url = '${connect_api().domain}/cancel_doc_addtime';
      var response = await Dio().post(url,
          data: {"doc_id": "$docid"},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        setState(() {
          onRefresh();
        });
        success_dialog(
          detail: 'alertdialog_lg.success',
        ).show(context);
      } else {}
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  Future onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    _update_isOpenKey();
    await shareprefs();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: ListView.builder(
                itemCount: add_time_List.length,
                itemBuilder: (context, index) {
                  indexopen = index;
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
                  return indentStatus == 'waiting'
                      ? Custom_card_uptime_request(
                          isOpentalling: _isOpen[index] ?? false,
                          isOpenButtons: true,
                          isTextbuttons: true,
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
                          onChang: (value) {
                            setState(() {
                              _isOpen[index] = value;
                            });
                          },
                          onEdite: () => _onEdite(index),
                          onCancel: () => _oncancel(index),
                          editeButtons: () => _onEdite(index),
                          cancelButtons: () => _oncancel(index),
                        )
                      : SizedBox();
                }),
          ),
        ),
        loading
            ? LoadingComponent()
            : countLeaveW == 0
                ? information_not_found()
                : SizedBox()
      ],
    );
  }

  Future _update_isOpenKey() async {
    setState(() {
      _isOpen[indexopen] = false;
    });
  }

  void _oncancel(int index) {
    cancel_adtime(add_time_List[index].docId.toString());
  }

  void _onEdite(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Edite_improve_uptime_page(
            des: add_time_List[index].description,
            docid: add_time_List[index].docId,
            time: add_time_List[index].shiftDate,
          ),
        )).then(
      (value) {
        if (value == null) {
          onRefresh();
        } else {
          onRefresh();
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
