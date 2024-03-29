// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, unused_field, unused_import, unnecessary_cast

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/Camera/camera_and_gallary.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/DropDownWidget/DropDown_CM.dart';
import 'package:eztime_app/Model/Get_Model/leave/Request_leave/Request_leave_Model.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart'
    as docList;
import 'package:eztime_app/Page/login/login_Page.dart';
import 'package:eztime_app/Page/submit_documents/appeove/ot/tapbar_apporv_ot.dart';
import 'package:eztime_app/Page/submit_documents/logRequest/request_leave_one.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/tapbar_logrequest_leave.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/PushLeave/PushLeavService.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/Request_leave_Service.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
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
  bool loading = false;
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
  int notificationCount = 0;
  List _item = [];
  Request_leave_Model _laeveList = Request_leave_Model();
  List<Data> _coutList = [];
  List<DateTime?> _dates = [];
  DateTime _dayBuilder = DateTime.now();
  bool isWeekend = DateTime.now().weekday == DateTime.saturday ||
      DateTime.now().weekday == DateTime.sunday;
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  DateFormat _Sformat = DateFormat('dd-MM-y');
  int countLeaveW = 0;

  Future getleave() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    var service = Request_leave_Service();
    var response = await service.model(token);

    //
    if (response == null) {
      log('getleavefaile');
      setState(() {
        loading = false;
      });
    } else {
      _laeveList.data = response;
      // get_One_leave();
      setState(() {
        for (var element in _laeveList.data!) {
          if (element.label != null) {
            if (element.label is Iterable<String>) {
              _item.addAll(element.label
                  as Iterable); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            } else if (element.label is String) {
              _item.add(
                element.label,
              ); // ใส่ ! เพื่อบอกว่าข้อมูลไม่เป็น null
            }
          }
        }

        loading = false;
      });
    }
  }

  // Future get_One_leave() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     var response = await get_DocOne_Service().model(token);
  //     setState(() {
  //       _coutList = response;

  //       countLeaveW = _coutList
  //         .where(
  //             (coutList) => coutList.status![0] == 'W')
  //         .length;
  //     });

  //   } catch (e) {
  //     //Dialog_internetError.showCustomDialog(context);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    getleave();
    super.initState();
  }

  showImage() {
    // ที่อยู่ของรูปภาพ

    String image = '${pickedImage!.path}';
    log('message: images ${image}');
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
        selectedDayHighlightColor: Theme.of(context).primaryColor,
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
        if (result != null && result.isNotEmpty) {
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
        selectedDayHighlightColor: Theme.of(context).primaryColor,
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
      if (result != null && result.isNotEmpty) {
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

  images_parse(XFile picked) {
    imagePath = picked.path;
    imagePathname = picked.name;
    if (imagePath == null ||
        imagePath!.isEmpty ||
        imagePathname == null ||
        imagePathname!.isEmpty) {
      setState(() {
        imagePath = '';
        imagePathname = '';
      });
    }
  }

  _onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    await showImage();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('Request leave.title').tr(),
              actions: [
                loading
                    ? Container()
                    : badges.Badge(
                        position: badges.BadgePosition.topEnd(end: 8, top: 8),
                        badgeContent: Text(
                          countLeaveW.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      tapbar_logrequest_leave(),
                                ));
                              },
                              icon: Icon(Icons.receipt)),
                        ),
                      )
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                  vertical: MediaQuery.of(context).size.height * 0.04),
              child: Buttons(
                  title: 'Get approval, Ot.Save'.tr(),
                  press: () async {
                    if (imagePathname == null || imagePathname!.isEmpty) {
                      var service = PushLeave_Service();
                      var response = await service.model(
                        token,
                        _laeveList.data![selectedValue!].value,
                        _Startdate,
                        _Enddate,
                        '',
                        '',
                        leaveDescription.text,
                      );
                      log('responseStatus: ${response}');
                      if (response == 200) {
                        Dialog_Success.showCustomDialog(context);
                      } else {
                        Dialog_false.showCustomDialog(context);
                      }
                    } else {
                      var service = PushLeave_Service();
                      var response = await service.model(
                          token,
                          _laeveList.data![selectedValue!].value,
                          _Startdate,
                          _Enddate,
                          imagePath!,
                          imagePathname!,
                          leaveDescription.text);
                      if (response == 200) {
                        Dialog_Success.showCustomDialog(context);
                      } else {
                        Dialog_false.showCustomDialog(context);
                      }
                    }
                  }),
            ),
            body: RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: loading
                  ? LoadingComponent()
                  : ListView(
                      padding: EdgeInsets.all(8),
                      children: [
                        Form(
                            key: _formkey,
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
                                        return null;
                                      },
                                      onTap: () async {
                                        await _datefill();
                                        timeOfDay__datefill = await _time;
                                        setState(() {
                                          print(timeOfDay__datefill);
                                          if (timeOfDay__datefill == null) {
                                            Dialog_date_alert()
                                                .showCustomDialog(context);
                                          } else {
                                            _datecontrollorStart.text =
                                                '${_Startdate} ${timeOfDay__datefill!.format(context)}';
                                          }
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
                                            color: Colors
                                                .grey), // สีข้อความในฮินท์
                                        prefixIcon: Icon(Icons.calendar_month,
                                            color:
                                                Theme.of(context).primaryColor),
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
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        ), // สีไอคอน
                                        filled: true,
                                        fillColor: Colors.white, // สีพื้นหลัง

                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              style: BorderStyle.solid),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              style: BorderStyle.solid),
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
                                          if (timeOfDay__datefill == null) {
                                            Dialog_date_alert()
                                                .showCustomDialog(context);
                                          } else {
                                            _datecontrollorEnd.text =
                                                '${_Enddate} ${timeOfDay_datefill2!.format(context)}';
                                          }
                                        });
                                      },
                                      controller: _datecontrollorEnd,
                                      readOnly: true,

                                      style: TextStyle(
                                          color: Colors.black), // สีของข้อความ
                                      decoration: InputDecoration(
                                        // ระยะห่างระหว่างข้อความและขอบ
                                        hintText:
                                            'Request leave.End Choose a time period'
                                                .tr(),
                                        hintStyle: TextStyle(
                                            color: Colors
                                                .grey), // สีข้อความในฮินท์
                                        prefixIcon: Icon(Icons.calendar_month,
                                            color:
                                                Theme.of(context).primaryColor),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _datecontrollorEnd.clear();
                                            setState(() {
                                              _dates = [];
                                            });
                                          },
                                          icon: Icon(
                                              Icons.highlight_remove_outlined,
                                              color: _datecontrollorEnd
                                                      .text.isEmpty
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        ), // สีไอคอน
                                        filled: true,
                                        fillColor: Colors.white, // สีพื้นหลัง
                                        contentPadding: EdgeInsets.all(6),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              style: BorderStyle.solid),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    style: BorderStyle.solid),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    style: BorderStyle.solid),
                                              )),
                                          maxLines: 4,
                                        ),
                                        // รับข้อความหลายบรรทัด
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Request leave.AddImage').tr(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      pickedImage == null
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
                                                                  fontSize:
                                                                      16)),
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
                                                                            pickedImage =
                                                                                value;
                                                                            if (pickedImage!.name.isNotEmpty ||
                                                                                pickedImage!.path.isNotEmpty) {
                                                                              images_parse(pickedImage!);
                                                                            }

                                                                            _onRefresh();
                                                                            log('fill1: ${value}');
                                                                            log('imagePathname: ${pickedImage}');
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
                                                                          } else {
                                                                            pickedImage =
                                                                                value;
                                                                            if (pickedImage!.name.isNotEmpty ||
                                                                                pickedImage!.path.isNotEmpty) {
                                                                              images_parse(pickedImage!);
                                                                            }
                                                                            _onRefresh();
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
                                                label: Text(
                                                        'Request leave.AddImage')
                                                    .tr(),
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  height: 250,
                                                  child: showImage()),
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
                      ],
                    ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
          );
  }
}
