import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/leave_Custom_card/request/Custom_card_request.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/date_time_parse/date_time_parse.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/Images_doc_Model/Images_doc_Model.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/Page/documents/request/leave/Edite_Leave/Edite_leave.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_leave_status_waiting extends StatefulWidget {
  const request_leave_status_waiting({super.key});

  @override
  State<request_leave_status_waiting> createState() =>
      _request_leave_status_waitingState();
}

class _request_leave_status_waitingState
    extends State<request_leave_status_waiting>
    with AutomaticKeepAliveClientMixin {
  int countLeaveW = 0;
  int indexopen = 0;
  var appeoveleng;
  ScrollController _contro = ScrollController();
  // bool isOpen = false;
  Images_doc_Model_leavelist dataimages = Images_doc_Model_leavelist();
  String? _imagesleave;
  @override
  void initState() {
    loading = true;
    // debugPrint('isOpen: $isOpen');
    shareprefs();
    // TODO: implement initState
    super.initState();
  }

  // A map to track the expansion state of each tile
  Map<int, bool> _isOpen = {};
  // Simulate a list of items with unknown length
  // final List<String> _items = List<String>.generate(100, (i) => "Item $i");
  List<Data> leaveList = [];
  bool loading = false;
  bool imageload = false;
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
    //await get_Device_token_service().model(token);
    await _get_leave();
  }

  Future _get_images(docid) async {
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
        debugPrint('cancel_leave: ${response.statusCode}');
        _onRefresh();
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  Future _get_leave() async {
    try {
      setState(() {
        loading = true;
      });
      get_leavelist_one_Model getoneleave = get_leavelist_one_Model();
      getoneleave.data = await get_DocOne_Service().model(token);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        leaveList = getoneleave.data!;
        countLeaveW = leaveList
            .where((_approveList) => _approveList.status == 'waiting')
            .length;
        loading = false;
        // isOpen = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Future _onRefresh() async {
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
            onRefresh: () => _onRefresh(),
            child: Scrollbar(
             thickness: 10,
             radius: Radius.circular(8),
              trackVisibility: true,
              child: ListView.builder(
                  itemCount: leaveList.length,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  itemBuilder: (context, index) {
                    indexopen = index;
                    _parsedattime(index);
                    var docotApprove = leaveList[index].docApprove;
                    String status;
                    var indentStatus = leaveList[index].status;
                    if (indentStatus == 'waiting') {
                      status = 'Leaverequestlist.Waiting_for_approval'.tr();
                    } else if (indentStatus == 'approved') {
                      status = 'Leaverequestlist.Approved'.tr();
                    } else {
                      status = 'Leaverequestlist.cancelled'.tr();
                    }
                    return indentStatus == 'waiting'
                        ? Custom_card_request(
                            isOpentalling: _isOpen[index] ?? false,
                            isOpenButtons: true,
                            isTextbuttons: true,
                            employeetitle: 'Leaverequestlist.name',
                            employeename:
                                // '${leaveList[index].docId}',
                                '${leaveList[index].employee?.firstName} ${leaveList[index].employee?.lastName}',
                            status: status,
                            indentStatus: '$indentStatus',
                            starttimetitle: 'Leaverequestlist.starttime',
                            startdate: '$datest $timest',
                            enddatetitle: 'Leaverequestlist.endTime',
                            endDate: '$enddate $endtime',
                            createtitle: 'Approve_leave.create',
                            createDate: '$createDate $createtime',
                            leavetitle: 'Leaverequestlist.Leavetype',
                            leaveType: '${leaveList[index].leave?.leaveType}',
                            detailtitle: 'Leaverequestlist.details',
                            detail: '${leaveList[index].description}',
                            listApprov: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 0),
                                itemCount: docotApprove?.length,
                                itemBuilder: (context, index) {
                                  String appoveStatus;
                                  var appeoveStatus = docotApprove?[index].status;
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
                                  int approvelistleng = index +1 ;
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 25,
                                    dense: true,
                                    leading: Wrap(
                                    children: [
                                      Text('ลำดับที่ $approvelistleng',style: TextStyles.textStyleapprove_list,),
                                      SizedBox(width: 5,),
                                      Text(
                                          '${docotApprove?[index].employeeName}'),
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
                            onPicture: () => setState(() {
                              loading = true;
                              imageload = true;
                              _onPicture(index);
                            }),
                            onEdite: () => _onEdite(index),
                            onCancel: () => _onCancel(index),
                            editeButtons: () => _onEdite(index),
                            cancelButtons: () => _onCancel(index),
                            onChang: (expanded) async {
                              setState(() {
                                _isOpen[index] = expanded;
                                // isOpen = expanded;
                              });
                            },
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

  void _parsedattime(int index) {
    datest = dateparse(leaveList[index].startDate.toString());
    timest = timeparse(leaveList[index].startDate.toString());
    enddate = dateparse(leaveList[index].endDate.toString());
    endtime = timeparse(leaveList[index].endDate.toString());
    createDate = dateparse(leaveList[index].createAt.toString());
    createtime = timeparse(leaveList[index].createAt.toString());
  }

  void _onCancel(int index) {
    cancel_leave(leaveList[index].docId.toString());
  }

  void _onEdite(int index) {
    setState(() {
      var datimeSt = '${datest} $timest';
      var dattimeEnd = '${enddate} ${endtime}';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Edit_leave_page(
                    docid: leaveList[index].docId.toString(),
                    leaveName: leaveList[index].leave!.leaveType!,
                    startdate: datimeSt,
                    enddate: dattimeEnd,
                    detail: leaveList[index].description.toString(),
                    leavetype: leaveList[index].leave!.leaveId.toString(),
                  ))).then((value) {
        if (value == null) {
          _onRefresh();
        } else {
          _onRefresh();
        }
      });
    });
  }

  void _onPicture(int index) async {
    setState(() {
      loading = true;
      imageload = true;
    });
    debugPrint('statement');
    var service = get_pic_docService();
    var response =
        await service.model(token, leaveList[index].docId.toString());
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
      setState(
        () {
          Future.delayed(Duration(milliseconds: 500)).then((value) {
            show_picture(response);
            loading = false;
            imageload = false;
          });
        },
      );
    }
  }

  void show_picture(_imagesleave) async {
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
