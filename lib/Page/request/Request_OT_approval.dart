// ignore_for_file: unnecessary_null_comparison, unused_import, unused_local_variable, unused_field
import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/get_Ot/get_Ot_service.dart';
import 'package:eztime_app/Components/APIServices/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/DropDownWidget/DropDown_CM.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart'
    as doclist;
import 'package:eztime_app/Model/Get_Model/Ot/get_ot/get_Ot_Model.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:eztime_app/Page/request/appeove/approve_ot.dart';
import 'package:eztime_app/Page/request/request/request_ot.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_OT_approval extends StatefulWidget {
  const Request_OT_approval({super.key});

  @override
  State<Request_OT_approval> createState() => _Request_OT_approvalState();
}

class _Request_OT_approvalState extends State<Request_OT_approval> {
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  bool load = false;
  bool _cleariconfile1 = false;
  bool _cleariconfile2 = false;
  String? selecteStr;
  int? selectedValue;
  List<doclist.DocList> docList = [];
  List<DateTime?> _dates = [];
  TimeOfDay? timeOfDay__datefill;
  TimeOfDay? timeOfDay_datefill2;
  int notificationCount = 0;

  ///--------------------------------------------------------------------------------------------------------------------------
  bool readOnly = true;
  bool showResetIcon = true;
  List<Ot> _otdata = [];
  List _item = [];
  var _Startdate;
  var _time;
  var _Endtime;
  var _timeEnd;
  var _Enddate;
  List _datadate = [];
  var resule1;
  var _fordate;
  var _for1date;
  var token;
  var otid;
  @override
  void initState() {
    InternetConnectionChecker().checker();
    SharedPrefs();
    super.initState();
  }

  SharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    log(token);
    _get_ot();
  }

  Future ad_ot(
      ot_id, startDate, startTime, endDate, endTime, description) async {
    try {
      String url = '${connect_api().domain}/add_ot';
      var response = await Dio().post(url,
          data: {
            "ot_id": "$ot_id",
            "startDate": "$startDate",
            "startTime": "$startTime",
            "endDate": "$endDate",
            "endTime": "$endTime",
            "description": "$description"
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        Dialog_Tang().successdialog(context);
      } else {
        Dialog_Tang().falsedialog(context);
      }
    } catch (e) {
      Dialog_Tang().falsedialog(context);
    }
  }

  Future _get_ot() async {
    try {
      setState(() {
        load = true;
      });
      var response = await get_Ot_Service().model(token);
      var get_ot = await get_doc_Ot_list_one_Service().model(token);
      if (response is int) {
        log('message1');
      } else {
        _otdata = response;
        for (var element in _otdata) {
          if (element.otName != null) {
            if (element.otName is Iterable<String>) {
              _item.addAll(element.otName
                  as Iterable); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            } else if (element.otName is String) {
              _item.add(
                element.otName,
              ); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            }
          }
        }
         setState(() {
        load = false;
      });
        if (get_ot == null) {
        } else {
          docList = get_ot;
         notificationCount = docList.length;
          setState(() {
        load = false;
      });
        }
      }
    } catch (e) {
      Dialog_Tang().interneterrordialog(context);
      log(e.toString());
       setState(() {
        load = false;
      });
    }
  }

  Future _datefill() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.single,
        dayTextStyle: TextStyle(),
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        selectedDayHighlightColor: Colors.blue,
        closeDialogOnOkTapped: true,
        centerAlignModePicker: true,
        firstDate: DateTime.now(),
      ),
      dialogBackgroundColor: Colors.white,
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    ).then((result) {
      if (result!.isNotEmpty) {
        log(result.toString());
        _time = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 08:00:00.000')),
        );
        var _date = result.toString();
        var formatdate =
            _date.split('[').last.split(']').first.split(' ').first;
        _Startdate = '$formatdate';
      } else {
        _Startdate = '';
        _time = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 08:00:00.000')),
        );
        var date = DateTime.now().toString();
        var formatdate = date.split('[').last.split(']').first.split(' ').first;
        _Startdate = '$formatdate';
      }
    });
  }

  Future datefill2() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.single,
        dayTextStyle: TextStyle(),
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        selectedDayHighlightColor: Colors.blue,
        closeDialogOnOkTapped: true,
        centerAlignModePicker: true,
        firstDate: DateTime.now(),
        // okButton:
      ),
      dialogBackgroundColor: Colors.white,
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    ).then((result) {
      print(result);
      if (result!.isNotEmpty) {
        _timeEnd = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var _date = result.toString();
        var formatdate =
            _date.split('[').last.split(']').first.split(' ').first;
        _Enddate = '${formatdate}';
      } else {
        _Enddate = '';
        _timeEnd = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var date = DateTime.now().toString();
        var formatdate = date.split('[').last.split(']').first.split(' ').first;
        _Enddate = '$formatdate';
      }
    });
  }

  bool _text_open_buttons = false;

  @override
  Widget build(BuildContext context) {
    return load ? Loading() : Scaffold(
        appBar: AppBar(
          title: Text('Get approval, Ot.title').tr(),
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(end: 8,top: 8),
              badgeContent: Text(
                notificationCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Request_ot_page(),));
                }, icon: Icon(Icons.receipt)),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.35,
              vertical: MediaQuery.of(context).size.height * 0.05),
          child: Buttons(
              title: 'Get approval, Ot.Save'.tr(),
              press: () {
                ad_ot(otid, _Startdate, timeOfDay__datefill, _Enddate,
                    timeOfDay_datefill2, leaveDescription.text);
              }),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            SizedBox(
              height: 20,
            ),
            Drop_Down(
              title: 'เลือกประเภท OT',
              item: _item,
              value: selecteStr,
              onChang: (p0) {
                setState(() {
                  selectedValue = _item.indexOf(p0);
                  var sucessValue = selectedValue! + 1;
                  selecteStr = p0.toString();
                  var _laeveId = _item[selectedValue!];
                  otid = _otdata[selectedValue!].otId;
                  log(_laeveId.toString());
                });
              },
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(8),
                      child: TextFormField(
                        onTap: () async {
                          await _datefill();
                          timeOfDay__datefill = await _time;
                          setState(() {
                            print(timeOfDay__datefill);
                            _datecontrollorStart.text =
                                '${_Startdate} ${timeOfDay__datefill!.format(context)}';
                          });
                        },
                        controller: _datecontrollorStart,
                        readOnly: true,
                        style: TextStyle(color: Colors.black), // สีของข้อความ
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                          hintText: 'Get approval, Ot.Choose start time'.tr(),
                          hintStyle:
                              TextStyle(color: Colors.blue), // สีข้อความในฮินท์
                          prefixIcon:
                              Icon(Icons.calendar_month, color: Colors.blue),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _datecontrollorStart.clear();
                              setState(() {
                                _cleariconfile1 = false;
                                _text_open_buttons = false;
                              });
                            },
                            icon: Icon(Icons.highlight_remove_outlined,
                                color: _cleariconfile1
                                    ? Colors.blue
                                    : Colors.white),
                          ), // สีไอคอน
                          filled: true,
                          fillColor: Colors.white, // สีพื้นหลัง
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _datecontrollorStart.text.isNotEmpty
                        ? Material(
                            color: Colors.white,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(8),
                            ///////////////////////////////////////////////////////////
                            child: TextFormField(
                              onTap: () async {
                                await datefill2();
                                timeOfDay_datefill2 = await _timeEnd;
                                setState(() {
                                  print(timeOfDay_datefill2);
                                  _datecontrollorEnd.text =
                                      '${_Enddate} ${timeOfDay_datefill2!.format(context)}';
                                });
                              },
                              controller: _datecontrollorEnd,
                              readOnly: true,
                              style: TextStyle(
                                  color: Colors.black), // สีของข้อความ
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        10.0), // ระยะห่างระหว่างข้อความและขอบ
                                hintText:
                                    'Get approval, Ot.Choose the end period'
                                        .tr(),
                                hintStyle: TextStyle(
                                    color: Colors.blue), // สีข้อความในฮินท์
                                prefixIcon: Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _datecontrollorEnd.clear();
                                    setState(() {
                                      _text_open_buttons = false;
                                      _cleariconfile2 = false;
                                    });
                                  },
                                  icon: Icon(Icons.highlight_remove_outlined,
                                      color: _cleariconfile2
                                          ? Colors.blue
                                          : Colors.white),
                                ), // สีไอคอน
                                filled: true,
                                fillColor: Colors.white, // สีพื้นหลัง
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request leave.Details').tr(),
                        SizedBox(
                          height: 5,
                        ),
                        Material(
                          color: Colors.white,
                          // elevation: 3,
                          borderRadius: BorderRadius.circular(8),
                          child: TextFormField(
                            controller: leaveDescription,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(6),
                                border: InputBorder.none),
                            maxLines: 4, // รับข้อความหลายบรรทัด
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(8),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Text('Request leave.Pending Items').tr(),
                    //       SizedBox(height: 5),
                    //       Card(
                    //         child: Column(children: []),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
