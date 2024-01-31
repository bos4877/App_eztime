// ignore_for_file: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/GetLeave/getleave.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/approve_doc/approve.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Model/Get_Model/get_One/get_DocOne_Model/get_DocOne_Model.dart'
    as DocOne;
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_leave/get_leave_Model.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/View_OT_logs.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class promble_page extends StatefulWidget {
  const promble_page({super.key});

  @override
  State<promble_page> createState() => _promble_pageState();
}

class _promble_pageState extends State<promble_page> {
  bool loading = false;
  bool expanOpen = false;
  List<DocList> _data = [];
  List<Leave> _laeveList = [];
  List<EmployData> _profilelist = [];
  List<DocOne.DocList> _Doclist = [];
  String? img;
  var _profileService = get_profile_service();
  var service = get_doc_leave_Service();
  var token;
  Future getprofile() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('_acessToken');
      var response = await _profileService.getprofile(token);
      setState(() {
        log(response.toString());
        if (response == null) {
          Dialog_Tang().infodialog(context);
          log('faile');
          setState(() {
            loading = false;
          });
        } else {
          _profilelist = [response];
          log('success');
          setState(() {
            getonrLeave();
            loading = false;
          });
        }
      });
    } catch (e) {
      loading = false;
      log(e.toString());
      // Dialog_Tang().dialog(context);
    }
  }

  Future get_leave() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    log('tokenpromble: ${token}');
    try {
      var response = await service.model(token);
      if (response == null) {
        setState(() {
          loading = false;
        });
      } else {
        List<DocList> docList = response.docList!;
        _data = docList.map((docList) => docList).toList();
        for (var element in _data) {
          if (element.leave!.leaveType != null) {
            if (element.leave!.leaveType is Iterable<String>) {
              _laeveList.addAll(element.leave!.leaveType
                  as Iterable<Leave>); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            } else if (element.leave!.leaveType is String) {
              _laeveList
                  .add(element.leave!); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            }
          }
        }

        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  getonrLeave() async {
    setState(() {
      loading = true;
    });
    var service = get_DocOne_Service();
    var response = await service.model(token);
    if (response == null) {
      log('kuy');
      setState(() {
        loading = false;
      });
    } else {
      _Doclist = response;
      setState(() {
        loading = false;
      });
    }
  }

  _onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getprofile();
    get_leave();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        title: Text('Information.title').tr(),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: loading ? Loading()
           
            : _profilelist[0].role!.isEmpty
                ? Center(
                  child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      color: Colors.white,
                      child: Text('ไม่พบข้อมูล')),
                )
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      String status;
                      var indentStatus = _data[index].status;
                      if (indentStatus == 'W') {
                        status = 'รออนุมัติ';
                      } else if (indentStatus == 'A') {
                        status = 'อนุมัติเเล้ว';
                      } else {
                        status = 'ไม่อนุมัติ';
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                onExpansionChanged: (expanded) async {
                                  setState(() {
                                    expanded = false;
                                  });
                                },
                                trailing: Column(
                                  children: [
                                    //  !expanOpen ?
                                    Text('$status',
                                        style: TextStyle(
                                            color: indentStatus == 'W'
                                                ? Colors.amber
                                                : indentStatus == 'A'
                                                    ? Colors.green
                                                    : Colors.red))
                                  ],
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(
                                            color: Colors.grey.shade300,
                                            thickness: 1,
                                            indent: 5,
                                            endIndent: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'เวลาเริ่ม: ${_data[index].startDate} ${_data[index].startTime}'),
                                            IconButton(
                                                onPressed: () async {
                                                  var service =
                                                      get_pic_docService();
                                                  var response =
                                                      await service.model(
                                                          token,
                                                          _data[index]
                                                              .docLId
                                                              .toString());
                                                  Uint8List bytes = response;
                                                  return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Container(
                                                          width: 200,
                                                          height: 200,
                                                          child: Image.memory(
                                                              bytes),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.image_outlined,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                        Text(
                                            'เวลาสิ้นสุด: ${_data[index].endDate} ${_data[index].endTime}'),
                                        Text(
                                            'ประเภทการลา: ${_laeveList[index].leaveType}'),
                                        Text(
                                            'รายละเอียด: ${_data[index].description}'),
                                        Text('สถานะ: $status'),
                                        //รูปภาพ
                                      ],
                                    ),
                                  ),
                                  _data[index].status == 'A' ||
                                          _data[index].status == 'N'
                                      ? Container()
                                      : ButtonTwoAppprove(
                                          onPressBtSucess: () {
                                            var service = Approve_Service();
                                            log(_data[index].rowId.toString());
                                            var response = service.model(
                                                _data[index].rowId, status);
                                          },
                                          onPressBtcal: () {},
                                        ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        
                      ]);
                    }),
      ),
    );
  }

  Widget OneEmplo() {
    return ListView.builder(
        itemCount: _Doclist.length,
        itemBuilder: (context, index) {
          String status;
          var indentStatus = _Doclist[index].status;
          if (indentStatus == 'W') {
            status = 'รออนุมัติ';
          } else if (indentStatus == 'A') {
            status = 'อนุมัติเเล้ว';
          } else {
            status = 'ไม่อนุมัติ';
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        // Text(
                        //   '${_laeveList[index].leaveType}',
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ).tr(),
                      ],
                    ),
                    onExpansionChanged: (expanded) async {
                      setState(() {
                        expanded = false;
                      });
                    },
                    trailing: Column(
                      children: [
                        //  !expanOpen ?
                        Text('$status',
                            style: TextStyle(
                                color: indentStatus == 'W'
                                    ? Colors.amber
                                    : indentStatus == 'A'
                                        ? Colors.green
                                        : Colors.red))
                        // : Buttons(
                        //     title: 'title',
                        //     press: () {},
                        //   )
                      ],
                    ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'เวลาเริ่ม: ${_Doclist[index].startDate} ${_Doclist[index].startTime}'),
                                IconButton(
                                    onPressed: () async {
                                      var service = get_pic_docService();
                                      var response = await service.model(token,
                                          _Doclist[index].docLId.toString());
                                      Uint8List bytes = response;
                                      return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Container(
                                              width: 200,
                                              height: 200,
                                              child: Image.memory(bytes),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.image_outlined,
                                      size: 20,
                                    ))
                              ],
                            ),
                            Text(
                                'เวลาสิ้นสุด: ${_Doclist[index].endDate} ${_Doclist[index].endTime}'),
                            // Text(
                            //     'ประเภทการลา: ${_laeveList[index].leaveType}'),
                            Text('รายละเอียด: ${_Doclist[index].description}'),
                            Text('สถานะ: $status'),
                            // รูปภาพ
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              loading ? Loading() : Container()
            ],
          );
        });
  }

  static TextStyle statusStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
