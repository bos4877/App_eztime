// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, unused_field, unused_import, unnecessary_cast

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/PushLeave/PushLeavService.dart';
import 'package:eztime_app/Components/APIServices/RequestleaveService/Request_leave_Service.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/Camera/camera_and_gallary.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/DropDownWidget/DropDown_CM.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Get_Model/Request_leave/Request_leave_Model.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request_leave extends StatefulWidget {
  const Request_leave({super.key});

  @override
  State<Request_leave> createState() => _Request_leaveState();
}

class _Request_leaveState extends State<Request_leave> {
  final _formkey = GlobalKey<FormState>();
  bool load = false;
  var token;
  var _time;
  var _diff;
  var _timeEnd;
  var _Startdate;
  var _Enddate;
  XFile? pickedImage;
  String? imagePath;
  String? imagePathname;
  String? selecteStr;
  int? selectedValue;
  TimeOfDay? timeOfDay__datefill;
  TimeOfDay? timeOfDay_datefill2;
  List _item = [];
  List<Leave> _laeveList = [];
  List<DateTime?> _dates = [];
  DateTime _dayBuilder = DateTime.now();
  bool isWeekend = DateTime.now().weekday == DateTime.saturday ||
      DateTime.now().weekday == DateTime.sunday;
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  DateFormat _Sformat = DateFormat('dd-MM-y');

  Future getleave() async {
    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    var service = Request_leave_Service();
    var response = await service.model(token);
    log(response.toString());
    if (response == null) {
      log('getleavefaile');
      setState(() {
        load = false;
      });
    } else {
      _laeveList = response;
      setState(() {
        for (var element in _laeveList) {
          if (element.leaveType != null) {
            if (element.leaveType is Iterable<String>) {
              _item.addAll(element.leaveType
                  as Iterable); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            } else if (element.leaveType is String) {
              _item.add(
                element.leaveType,
              ); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            }
          }
        }
        load = false;
      });
    }
  }

  @override
  void initState() {
    InternetConnectionChecker().checker();
    getleave();
    super.initState();
  }

  Future fileToBase64(String filePath) async {
    File file = File(filePath);
    List<int> bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Widget showImage() {
    // ที่อยู่ของรูปภาพ
    String image = '${imagePathname}';

    // ตรวจสอบว่ารูปภาพมีหรือไม่
    File imageFile = File(image);
    if (!imageFile.existsSync()) {
      setState(() {
        log('showImage: ${imageFile}');
      });
    }
    // แสดงรูปภาพ
    return Image.file(imageFile);
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
    ).then(
      (result) {
        if (result!.isNotEmpty) {
          log(result.toString());
          _time = showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                DateTime.parse('2023-08-23 08:00:00.000')),
          );
          var _date = result.toString();
          var formatdate =
              _date.split('[').last.split(']').first.split(' ').first;
          _Startdate = '$formatdate';
        } else {
          _Startdate = '';
          _time = showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                DateTime.parse('2023-08-23 08:00:00.000')),
          );
          var date = DateTime.now().toString();
          var formatdate =
              date.split('[').last.split(']').first.split(' ').first;
          _Startdate = '$formatdate';
        }
      },
    );
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

  _onRefresh() async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    await showImage();
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Request leave.title').tr(),
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: load
            ? Loading()
            : ListView(
                children: [
                  Form(
                    key: _formkey,
                    child: Container(
                      // height: 40,
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Drop_Down(
                                  title: 'Request leave.select',
                                  item: _item,
                                  value: selecteStr,
                                  onChang: (value) {
                                    setState(() {
                                      selectedValue = _item.indexOf(value);
                                      var sucessValue = selectedValue! + 1;
                                      selecteStr = value.toString();
                                      var _laeveId = _item[selectedValue!];

                                      print(selecteStr!);
                                      print('sucessValue: ${sucessValue}');
                                      print('selecteStr: ${selecteStr}');
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.white,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(8),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        Snack_Bar(
                                            snackBarColor: Colors.red,
                                            snackBarIcon:
                                                Icons.warning_amber_rounded,
                                            snackBarText:
                                                'กรุณากรอกวันที่เริ่มต้น');
                                      }
                                    },
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

                                    style: TextStyle(
                                        color: Colors.black), // สีของข้อความ
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // ระยะห่างระหว่างข้อความและขอบ
                                      hintText:
                                          'Request leave.Start Choose a time period'
                                              .tr(),
                                      hintStyle: TextStyle(
                                          color:
                                              Colors.grey), // สีข้อความในฮินท์
                                      prefixIcon: Icon(Icons.calendar_month,
                                          color: Colors.blue),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _datecontrollorStart.clear();
                                          setState(() {
                                            _dates = [];
                                          });
                                        },
                                        icon: Icon(
                                            Icons.highlight_remove_outlined,
                                            color: _datecontrollorStart
                                                    .text.isEmpty
                                                ? Colors.white
                                                : Colors.blue),
                                      ), // สีไอคอน
                                      filled: true,
                                      fillColor: Colors.white, // สีพื้นหลัง
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide:
                                            BorderSide.none, // ไม่มีเส้นขอบ
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.white,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(8),
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
                                          'Request leave.End Choose a time period'
                                              .tr(),
                                      hintStyle: TextStyle(
                                          color:
                                              Colors.grey), // สีข้อความในฮินท์
                                      prefixIcon: Icon(Icons.calendar_month,
                                          color: Colors.blue),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _datecontrollorEnd.clear();
                                          setState(() {
                                            _dates = [];
                                          });
                                        },
                                        icon: Icon(
                                            Icons.highlight_remove_outlined,
                                            color:
                                                _datecontrollorEnd.text.isEmpty
                                                    ? Colors.white
                                                    : Colors.blue),
                                      ), // สีไอคอน
                                      filled: true,
                                      fillColor: Colors.white, // สีพื้นหลัง
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide:
                                            BorderSide.none, // ไม่มีเส้นขอบ
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Request leave.AddImage').tr(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    imagePathname == null
                                        ? Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        title: Text(
                                                            'เลือกรูปภาพ',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        content: Container(
                                                          width: 80,
                                                          height: 100,
                                                          child: Column(
                                                            children: [
                                                              TextButton.icon(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    await camera()
                                                                        .then(
                                                                      (value) {
                                                                        if (value ==
                                                                            null) {
                                                                          Snack_Bar(
                                                                              snackBarColor: Colors.red,
                                                                              snackBarIcon: Icon(Icons.warning_amber_outlined),
                                                                              snackBarText: 'ไม่พบรูปภาพ');
                                                                        } else {
                                                                          imagePathname =
                                                                              value;
                                                                          _onRefresh();
                                                                          log('fill1: ${value}');
                                                                          log('imagePathname: ${imagePathname}');
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .camera_alt),
                                                                  label: Text(
                                                                    'กล้อง',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  )),
                                                              TextButton.icon(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);

                                                                    await gallery()
                                                                        .then(
                                                                      (value) {
                                                                        if (value ==
                                                                            null) {
                                                                          log('value: ${value}');
                                                                          // _onRefresh();
                                                                        } else {
                                                                          imagePathname =
                                                                              value;
                                                                          _onRefresh();
                                                                          log('imagePathname: ${imagePathname}');
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .photo),
                                                                  label: Text(
                                                                    'คลังภาพ',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ))
                                                            ],
                                                          ),
                                                        ));
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons
                                                  .add_photo_alternate_outlined),
                                              label:
                                                  Text('Request leave.AddImage')
                                                      .tr(),
                                            ),
                                          )
                                        : Center(
                                            child: Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              height: 300,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: showImage(),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ])),
                    ),
                  )
                ],
              ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: Buttons(
            title: 'Request leave.Save'.tr(),
            press: () async {
              var base64 = await fileToBase64(imagePathname!);
              log('base64: ${base64}');
              log('_laeveList[selectedValue].leaveId: ${_laeveList[selectedValue!].leaveId}');
              var service = PushLeave_Service();
              var startTime = timeOfDay__datefill
                  .toString()
                  .split('(')
                  .last
                  .split(')')
                  .first;
              var endTime = timeOfDay_datefill2
                  .toString()
                  .split('(')
                  .last
                  .split(')')
                  .first;
              var response = await service.model(
                token,
                _laeveList[selectedValue!].leaveId,
                _Startdate,
                startTime,
                _Enddate,
                endTime,
                leaveDescription.text,
                base64,
              );
              log('responseStatus: ${response}');
              if (response == 200) {
                Dialog_Tang().successdialog(context);
              } else {
                Dialog_Tang().falsedialog(context);
              }
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
