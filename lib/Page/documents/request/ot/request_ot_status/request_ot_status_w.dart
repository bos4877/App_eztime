import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/ot_Custom_card/request/Custom_card_ot_request.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_pop_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/Page/documents/request/ot/Edite_ot/Edite_ot.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_ot_status_waiting extends StatefulWidget {
  const request_ot_status_waiting({super.key});

  @override
  State<request_ot_status_waiting> createState() =>
      _request_ot_status_waitingState();
}

class _request_ot_status_waitingState extends State<request_ot_status_waiting>
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
  List<Data> otList = [];
  bool loading = false;
  var _startdate;
  var _starttime;
  var _enddate;
  var _endtime;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    _get_ot(token);
  }

  Future _get_ot(tokn) async {
    try {
      setState(() {
        loading = true;
      });
      var getoneot = await get_doc_Ot_list_one_Service().model(tokn, context);

      await Future.delayed(Duration(milliseconds: 500));
      if (getoneot is int) {
        false_dialog(
          detail: '',
        ).show(context);
      } else {
        otList = getoneot;
        setState(() {
          countLeaveW = otList.where((ot) => ot.status == 'waiting').length;
          loading = false;
        });
      }
    } catch (e) {
      log(e.toString());
      loading = false;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _onRefresh() async {
    setState(() {
      loading = true;
    });
    try {
      debugPrint('statement');
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: ListView.builder(
                itemCount: otList.length,
                itemBuilder: (context, index) {
                  _datetimeparse(index);
                  indexopen = index;
                  List<DocApprove> docotApprove =
                      otList[index].docApprove ?? [];
                  String status;
                  String _otstartdate =
                      dateparse(otList[index].startDate.toString());
                  String _otstarttime =
                      timeparse(otList[index].startDate.toString());
                  String _otenddate =
                      dateparse(otList[index].endDate.toString());
                  String _otendtime =
                      timeparse(otList[index].endDate.toString());
                  var indentStatus = otList[index].status;
                  if (indentStatus == 'waiting') {
                    status = 'OT_request_list.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'OT_request_list.Approved'.tr();
                  } else {
                    status = 'OT_request_list.cancelled'.tr();
                  }
                  return indentStatus == 'waiting'
                      ? Custom_card_ot(
                          isOpentalling: _isOpen[index] ?? false,
                          isOpenButtons: true,
                          isTextbuttons: true,
                          employeetitle: 'OT_request_list.name',
                          employeename:
                              // '${otList[index].docId}',
                              '${otList[index].employee?.firstName} ${otList[index].employee?.lastName}',
                          status: status,
                          indentStatus: '$indentStatus',
                          starttimetitle: 'OT_request_list.starttime',
                          startdate: '$_otstartdate $_otstarttime',
                          enddatetitle: 'OT_request_list.endTime',
                          endDate: '$_otenddate $_otendtime',
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
                               int approvelistleng = index + 1;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 25,
                                  dense: true,
                                  leading: Wrap(
                                    children: [
                                      Text('ลำดับที่ $approvelistleng',style: TextStyles.textStyleapprove_list,),
                                      SizedBox(width: 5,),
                                      Text(
                                          '${docotApprove[index].employeeName}'),
                                    ],
                                  ),
                                  trailing: Text('${appoveStatus}',
                                      style: TextStyle(
                                          color: appeoveStatus == 'waiting'
                                              ? Colors.amber
                                              : appeoveStatus == 'approved'
                                                  ? Colors.green
                                                  : Colors.red)),
                                );
                              }),
                          onChang: (expanded) {
                            setState(() {
                              _isOpen[index] = expanded;
                            });
                          },
                          onEdite: () => _onEdite(index),
                          onCancel: () => _onCancel(index),
                          editeButtons: () => _onEdite(index),
                          cancelButtons: () => _onCancel(index),
                        )
                      : Container();
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

  Future cancel_ot(String docId) async {
    setState(() {
      loading = true;
    });
    try {
      await Future.delayed(Duration(seconds: 1));
      String url = '${connect_api().domain}/cancel_doc_ot';
      var response = await Dio().post(url,
          data: {"doc_id": "$docId"},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        debugPrint('cancel_ot: ${response.statusCode}');
        success_dialog(
          detail: 'ยกเลิกเอกสารสำเร็จ',
        ).show(context);
        _onRefresh();
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      debugPrint('DioError: ${data}');
      setState(() {
        _onRefresh();
      });
      false_pop_dialog(
        detail: '$message',
      ).show(context);
    }
  }

  void _datetimeparse(int index) {
    _startdate = dateparse(otList[index].startDate.toString());
    _starttime = timeparse(otList[index].startDate.toString());
    _enddate = dateparse(otList[index].endDate.toString());
    _endtime = timeparse(otList[index].endDate.toString());
  }

  void _onCancel(int index) {
    cancel_ot(otList[index].docId.toString());
  }

  void _onEdite(int index) {
    setState(() {
      var datimeSt = '$_startdate $_starttime';
      var dattimeEnd = '$_enddate $_endtime';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Edit_ot_page(
                    docid: otList[index].docId,
                    startdate: datimeSt,
                    enddate: dattimeEnd,
                    desc: otList[index].description,
                    ottype: otList[index].ot?.otName,
                    otvalue: otList[index].ot?.otId,
                    shipdate: otList[index].shiftDate,
                  ))).then((value) {
        if (value == null) {
          _onRefresh();
        } else {
          _onRefresh();
        }
      });
    });
  }

  void show_picture(_imagesleave) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 350,
            height: 350,
            child: Image.network(
              '${_imagesleave}',
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
