import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_pop_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog_close.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_appreove_leave/get_appreove_leave.dart';
import 'package:eztime_app/Page/documents/appeove/leave/approve_leave_status/ui_leave_approve/ui_leave_status.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_leave/approve.dart';
import 'package:eztime_app/controller/APIServices/approve/approve_leave/get_Apporev_leave.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class status_waiting extends StatefulWidget {
  const status_waiting({super.key});

  @override
  State<status_waiting> createState() => _status_waitingState();
}

class _status_waitingState extends State<status_waiting>
    with AutomaticKeepAliveClientMixin {
  int countLeaveW = 0;
  String? _imagesleave;
  bool loadimages = false;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  // A map to track the expansion state of each tile
  Map<int, bool> _isOpen = {};
  // Simulate a list of items with unknown length
  final List<String> _items = List<String>.generate(100, (i) => "Item $i");
  List<DocList> approveList = [];
  bool loading = false;
  var datest;
  var timest;
  var enddate;
  var endtime;
  var createDate;
  var createtime;
  var token;
  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');

    _get_leave();
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      var getoneleave =
          await get_appreove_leave_Service().model(token, context);
      setState(() {
        approveList = getoneleave;
        countLeaveW = approveList
            .where((_approveList) => _approveList.statusApprove == 'waiting')
            .length;
      });
    } on DioError catch (e) {
      var data = e.response?.data.toString();
      var message = data?.split(':').last.split('}').first;
      log('message: ${message}');
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  onGoblack() async {
    await shareprefs();
  }

  _get_images(docid) async {
    setState(() {
      loading = true;
    });
    var get_images = await get_pic_docService().model(token, docid);
    setState(() {
      _imagesleave = get_images;
      loading = false;
    });
    return get_images;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () => onGoblack(),
            child: ListView.builder(
                itemCount: approveList.length,
                itemBuilder: (context, index) {
_parsedattime(index);
                  String status;
                  var indentStatus = approveList[index].statusApprove;
                  if (indentStatus == 'waiting') {
                    status = 'Approve_leave.Waiting_for_approval'.tr();
                  } else if (indentStatus == 'approved') {
                    status = 'Approve_leave.Approved'.tr();
                  } else {
                    status = 'Approve_leave.cancelled'.tr();
                  }
                  return indentStatus == 'waiting'
                      ? ui_leave_status(
                          isOpentalling: _isOpen[index] ?? false,
                          isOpenButtons: true,
                          isTextbuttons: true,
                          title_name: 'Approve_leave.name',
                          name: '${approveList[index].employeeName}',
                          status: status,
                          indentStatus: '$indentStatus',
                          title_starttime: 'Approve_leave.starttime',
                          starttime: '${approveList[index].startDate}',
                          title_endtime: 'Approve_leave.endTime',
                          endtime: '${approveList[index].endDate}',
                          createtitle: 'Approve_leave.create',
                          createDate: '$createDate $createtime',
                          title_Leavetype: 'Approve_leave.Leavetype',
                          Leavetype: '${approveList[index].leaveType}',
                          title_detail: 'Approve_leave.details',
                          detail: '${approveList[index].description}',
                          onChang: (expand) {
                            setState(() {
                              _isOpen[index] = expand;
                            });
                          },
                          onPicture: () => _onPicture(index),
                          onApprove: () => _onApprove(index),
                          onCancel: () => _onCancel(index),
                        )
                      : SizedBox();
                }),
          ),
        ),
        loading
            ? loadimages
                ? Load_Cricle()
                : LoadingComponent()
            : countLeaveW == 0
                ? information_not_found()
                : SizedBox()
      ],
    );
  }

  void _parsedattime(int index) {
    createDate = dateparse(approveList[index].createDate.toString());
    createtime = timeparse(approveList[index].createDate.toString());
  }

  void _onCancel(int index) async {
    var response;
    var re;
    String statuscode = 'cancelled';
    response = await Approve_Leave_Service()
        .model(
      approveList[index].docId.toString(),
      statuscode,
      token,
    )
        .then((result) {
      if (result == 200) {
        success_dialog_close(
          detail: 'alertdialog_lg.success',
        ).show(context);
        onGoblack();
      } else {
        var data = result.toString();
        re = data.split(':').last.split('}').first;
        false_pop_dialog(
          detail: '$re',
        ).show(context);
      }
    });
  }

  void _onApprove(int index) async {
    var re;
    String statuscode = 'approved';
    var response = await Approve_Leave_Service()
        .model(approveList[index].docId.toString(), statuscode, token)
        .then((result) {
      if (result == 200) {
        success_dialog_close(
          detail: 'alertdialog_lg.success',
        ).show(context);
        onGoblack();
      } else {
        var data = result.toString();
        re = data.split(':').last.split('}').first;
        false_pop_dialog(
          detail: '$re',
        ).show(context);
      }
    });
  }

  void _onPicture(int index) async {
    setState(() {
      loading = true;
      loadimages = true;
    });
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
    } else {
      show_picture(response);
    }
  }

  void show_picture(_imagesleave) {
    setState(() {
      loading = true;
      loadimages = true;
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
      loading = false;
      loadimages = false;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
