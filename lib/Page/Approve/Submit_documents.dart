// ignore_for_file: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/GetLeave/getleave.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Model/Get_Model/get_leave/get_leave_Model.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/View_OT_logs.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App_rove_page extends StatefulWidget {
  const App_rove_page({super.key});

  @override
  State<App_rove_page> createState() => _App_rove_pageState();
}

class _App_rove_pageState extends State<App_rove_page> {
  bool load = false;
  List<DocList> _data = [];
  List<Leave> _laeveList = [];
  var service = get_doc_leave_Service();
  var token;
  // Future get_leave() async {
  //   setState(() {
  //     load = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('_acessToken');
  //   log('tokenpromble: ${token}');
  //   try {
  //     var response = await service.model(token);
  //     // log(response.toString().to);
  //     if (response == null) {
  //       setState(() {
  //         load = false;
  //       });
  //     } else {
  //       List<DocList> docList = response.docList!;
  //       _data = docList.map((docList) => docList).toList();
  //       for (var element in _data) {
  //         if (element.leave!.leaveType != null) {
  //           if (element.leave!.leaveType is Iterable<String>) {
  //             _laeveList.addAll(element.leave!.leaveType
  //                 as Iterable<Leave>); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
  //           } else if (element.leave!.leaveType is String) {
  //             _laeveList
  //                 .add(element.leave!); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
  //           }
  //         }
  //       }
  //       setState(() {
  //         load = false;
  //       });
  //     }
  //   } catch (e) {}
  // }

  _onRefresh() async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // get_leave();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information.title').tr(),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: load
            ? Loading()
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  var images = _data[index].file;
                  String base64Image = "$images";
                  Uint8List bytes = base64Decode(base64Image);
                  String status;
                  var indentStatus = _data[index].status;
                  if (indentStatus == 'W') {
                    status = 'รออนุมัติ';
                  } else if (indentStatus == 'A') {
                    status = 'อนุมัติเเล้ว';
                  } else {
                    status = 'ไม่อนุมัติ';
                  }
                  return  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Material(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.blue)),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.white,
                            title: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons_Svg/newspaper.svg',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${_laeveList[index].leaveType}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ).tr(),
                              ],
                            ),
                            onExpansionChanged: (expanded) {
                              setState(() {
                                expanded = false;
                              });
                            },
                            trailing: Text('$status',
                                style: TextStyle(
                                    color: indentStatus == 'W'
                                        ? Colors.amber
                                        : indentStatus == 'A'
                                            ? Colors.green
                                            : Colors.red)),
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                        indent: 5,
                                        endIndent: 5),
                                    Text(
                                        'เวลาเริ่ม: ${_data[index].startDate} ${_data[index].startTime}'),
                                    Text(
                                        'เวลาสิ้นสุด: ${_data[index].endDate} ${_data[index].endTime}'),
                                    Text(
                                        'ประเภทการลา: ${_laeveList[index].leaveType}'),
                                    Text(
                                        'รายละเอียด: ${_data[index].description}'),
                                    Text('สถานะ: $status'),
                                    Center(
                                      child: Image.memory(
                                          width: 300,
                                          height: 300,
                                          // color: Colors.red,
                                          bytes),
                                    )
                                  ],
                                ),
                              ),
                              _data[index].status == 'A' || _data[index].status == 'N'
                                  ? Container()
                                  : ButtonTwoAppprove(
                                      onPressBtSucess: () {},
                                      onPressBtcal: () {},
                                    ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      load ? Loading() : Container()
                    ],
                  );
                }),
      ),
    );
  }

  static TextStyle statusStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
