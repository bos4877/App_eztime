import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/leave_Custom_card/request/Custom_card_request.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_leave_status_Approved extends StatefulWidget {
  const request_leave_status_Approved({super.key});

  @override
  State<request_leave_status_Approved> createState() =>
      _request_leave_status_ApprovedState();
}

class _request_leave_status_ApprovedState
    extends State<request_leave_status_Approved>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    loading = true;
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  List<Data> approveList = [];
  bool loading = false;
  bool imageload = false;
  bool isOpentalling = false;
  int countLeaveA = 0;
  int countStatusA = 0;
  int appeoveCountdoc = 0;
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
      var getoneleave = await get_DocOne_Service().model(token);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        approveList = getoneleave;
        appeoveCountdoc = approveList.length;
        countStatusA =
            approveList.where((element) => element.status == 'approved').length;
        loading = false;
      });
      log(appeoveCountdoc.toString());
      log(countStatusA.toString());
    } catch (e) {
      loading = false;
      log(e.toString());
    }
  }

  onGoblack() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    await shareprefs();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: Scrollbar(
              thickness: 10,
              radius: Radius.circular(8),
              child: ListView.builder(
                  itemCount: approveList.length,
                  padding: EdgeInsets.only(left: 10,right: 10),
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
                    return indentStatus == 'approved'
                        ? Custom_card_request(
                            isOpentalling: false,
                            isOpenButtons: false,
                            isTextbuttons: false,
                            employeetitle: 'Approve_leave.name',
                            employeename:
                                '${approveList[index].employee?.firstName} ${approveList[index].employee?.lastName}',
                            status: status,
                            indentStatus: '$indentStatus',
                            starttimetitle: 'Approve_leave.starttime',
                            startdate: '$datest $timest',
                            enddatetitle: 'Approve_leave.endTime',
                            endDate: '$enddate $endtime',
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
                            onChang: (value) {},
                            onEdite: () {},
                            onCancel: () {},
                            editeButtons: () {},
                            cancelButtons: () {},
                          )
                        : SizedBox();
                  }),
            )),
      ),
      loading
          ? imageload
              ? Load_Cricle()
              : LoadingComponent()
          : countStatusA == 0
              ? information_not_found()
              : SizedBox()
    ]);
  }

  void _parsedattime(int index) {
    datest = dateparse(approveList[index].startDate.toString());
    timest = timeparse(approveList[index].startDate.toString());
    enddate = dateparse(approveList[index].endDate.toString());
    endtime = timeparse(approveList[index].endDate.toString());
    createDate = dateparse(approveList[index].createAt.toString());
    createtime = timeparse(approveList[index].createAt.toString());
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

  void _onPicture(int index) async {
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
      Future.delayed(Duration(milliseconds: 500)).then(
        (value) {
          show_picture(response);
          loading = false;
          imageload = false;
        },
      );
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
