import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/leave_Custom_card/request/Custom_card_request.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_leave_status_cancelled extends StatefulWidget {
  const request_leave_status_cancelled({super.key});

  @override
  State<request_leave_status_cancelled> createState() =>
      _request_leave_status_cancelledState();
}

class _request_leave_status_cancelledState
    extends State<request_leave_status_cancelled>
    with AutomaticKeepAliveClientMixin {
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
  List<Data> approveList = [];
  bool loading = false;
  bool imageload = false;
  // bool isOpentalling = false;
  String _imagesleave = '';
  int countLeaveN = 0;
  int appeoveCount = 0;
   var datest ;
   var timest;
   var enddate ;
   var endtime ;
    var createDate ;
    var createtime ;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    _get_leave();
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave = await get_DocOne_Service().model(token);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        approveList = getoneleave ?? [];
        appeoveCount = approveList.length;
        countLeaveN = approveList
            .where((_approveList) =>
                _approveList.docApprove?[0].status == 'cancelled')
            .length;

        loading = false;
      });
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } 
  }

  _get_images(docid) async {
    setState(() {
      loading = true;
    });
    var get_images = await get_pic_docService().model(token, docid);
    setState(() {
      _imagesleave = get_images;
      //  _imagesleave = dataimages.img!;
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
            onRefresh: () => _onRefresh(),
            child: Scrollbar(
              thickness: 10,
              radius: Radius.circular(8),
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10,right: 10),
                  itemCount: approveList.length,
                  itemBuilder: (context, index) {
                    _parsedattime(index);
                    var docotApprove = approveList[index].docApprove;
                    String status;
                    var indentStatus = approveList[index].status;
                    if (indentStatus == 'waiting') {
                      status = 'Approve_leave.Waiting_for_approval'.tr();
                    } else if (indentStatus == 'approved') {
                      status = 'Approve_leave.Approved'.tr();
                    } else {
                      status = 'Approve_leave.cancelled'.tr();
                    }
                    return indentStatus == 'cancelled'
                        ? Custom_card_request(
                            isOpenButtons: false,
                            isOpentalling: _isOpen[index] ?? false,
                            isTextbuttons: false,
                            employeetitle: 'Approve_leave.name',
                            employeename:
                                '${approveList[index].employee?.firstName} ${approveList[index].employee?.lastName}',
                            status: status,
                            indentStatus: '$indentStatus',
                            starttimetitle: 'Approve_leave.starttime',
                            startdate:
                                '$datest $timest',
                            enddatetitle: 'Approve_leave.endTime',
                            endDate:
                                '$enddate $endtime',
                                createtitle: 'Approve_leave.create',
                                createDate: '$createDate $createtime',
                            leavetitle: 'Approve_leave.Leavetype',
                            leaveType: '${approveList[index].leave?.leaveType}',
                            detailtitle: 'Approve_leave.details',
                            detail: '${approveList[index].description}',
                            listApprov: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: docotApprove?.length,
                                itemBuilder: (context, index) {
                                  String appoveStatus;
                                  var appeoveStatus = docotApprove?[index].status;
                                  if (appeoveStatus == 'waiting') {
                                    appoveStatus =
                                        'Approve_leave.Waiting_for_approval'.tr();
                                  } else if (appeoveStatus == 'approved') {
                                    appoveStatus = 'Approve_leave.Approved'.tr();
                                  } else {
                                    appoveStatus = 'Approve_leave.cancelled'.tr();
                                  }
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                     minTileHeight: 25,
                                    dense: true,
                                    leading: Text(
                                        '${docotApprove?[index].employeeName}'),
                                    trailing: Text('${appoveStatus}',
                                        style: TextStyle(
                                            color: appeoveStatus == 'waiting'
                                                ? Colors.amber
                                                : appeoveStatus == 'approved'
                                                    ? Colors.green
                                                    : Colors.red)),
                                  );
                                }),
                            onPicture: () => setState(() {
                              loading = true;
                              imageload = true;
                              _onPicture(index);
                            }),
                            onChang: (expanded) {
                              setState(() {
                                _isOpen[index] = expanded;
                              });
                            },
                            onEdite: () => {},
                            onCancel: () => _onCancel(index),
                            editeButtons: () => {},
                            cancelButtons: () => _onCancel(index),
                          )
                        : SizedBox();
                  }),
            ),
          ),
        ),
        loading
            ? imageload
                ? Load_Cricle()
                : LoadingComponent()
            : countLeaveN == 0
                ? information_not_found()
                : SizedBox()
      ],
    );
  }

  Future cancel_leave(String docId) async {
    setState(() {
      loading = true;
    });
    try {
      await Future.delayed(Duration(seconds: 1));
      String url = '${connect_api().domain}/cancel_doc_Leave';
      var response = await Dio().post(url,
          data: {"doc_id": "$docId"},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        _onRefresh();
      }
    } on DioError catch (e) {
      _get_leave();
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  Future _onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    await shareprefs();
    await _get_leave();
    setState(() {
      loading = false;
    });
  }

  void _onCancel(int index) {
    cancel_leave(approveList[index].docId.toString());
  }
  void _parsedattime(int index) {
    datest = dateparse(approveList[index].startDate.toString());
    timest = timeparse(approveList[index].startDate.toString());
    enddate = dateparse(approveList[index].endDate.toString());
    endtime = timeparse(approveList[index].endDate.toString());
     createDate = dateparse(approveList[index].createAt.toString());
     createtime = timeparse(approveList[index].createAt.toString());
  }

  void _onPicture(int index) async {
    setState(() {
      loading = true;
      imageload = true;
    });
    debugPrint('statement');
    var service = get_pic_docService();
    var response =
        await service.model(token, approveList[index].docId.toString());
    log(response.toString());
    if (response == 'ไม่พบรูปภาพ') {
      Snack_Bar(
              snackBarColor: Colors.red,
              snackBarIcon: Icons.warning_rounded,
              snackBarText: 'Leaverequestlist.Picture_not_found')
          .showSnackBar(context);
      loading = false;
      imageload = false;
    } else {
      setState(() {
        Future.delayed(Duration(milliseconds: 500)).then(
          (value) {
            show_picture(response);
            imageload = false;
            loading = false;
          },
        );
      });
    }
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
    setState(() {
      loading = false;
      imageload = false;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
