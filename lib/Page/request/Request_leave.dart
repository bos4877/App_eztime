// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, unused_field, unused_import

import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Request_leave extends StatefulWidget {
  const Request_leave({super.key});

  @override
  State<Request_leave> createState() => _Request_leaveState();
}

class _Request_leaveState extends State<Request_leave> {
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  DateFormat _Sformat = DateFormat('dd-MM-y');

  List<DateTime?> _dates = [];
  var _Startdate;
  var _Enddate;
  DateTime _dayBuilder = DateTime.now();
  String? selecteStr;
  int? selectedValue;
  List _item = ['ลากิจ', 'ลาป่วย', 'ลาไม่รับค่าจ้าง'];
  var _diff;
  bool load = false;
  var _time;
  var _timeEnd;
  bool isWeekend = DateTime.now().weekday == DateTime.saturday ||
      DateTime.now().weekday == DateTime.sunday;
  XFile? pickedImage;
  String? imagePath;
  String? imagePathname;

  @override
  void initState() {
      InternetConnectionChecker().checker();
    super.initState();
  }

  Future _pickImage() async {
    final pickedFile = await ImagePickerHelper.pickImage();

    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
        imagePath = pickedImage!.path;
        imagePathname = pickedImage!.name;
        log(imagePathname.toString());
        log(imagePath.toString());
      });
    } else {
      return Text('ไม่พบรูปภาพ');
    }
  }

  Widget showImage() {
    // ที่อยู่ของรูปภาพ
    String image = '${imagePath}';

    // ตรวจสอบว่ารูปภาพมีหรือไม่
    File imageFile = File(imagePath!);
    if (!imageFile.existsSync()) {
      return Text('ไม่พบรูปภาพ');
    }
    // แสดงรูปภาพ
    return Image.file(imageFile);
  }

  Future _date() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.range,
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
      print(result);
      if (result != null) {
        if (selectedValue == 0) {
          setState(() {
            if (result.length > 4) {
              print(result.length);
              _time = showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                    DateTime.parse('2023-08-23 08:00:00.000')),
              );
              print(_time);
            } else {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.warning,
                title: 'การแจ้งเตือน',
                titleTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                desc: 'ลากิจได้ไม่เกิน 4 วัน\n รวมเสาร์-อาทิต นะคะ',
                btnOkOnPress: () {},
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false,
              )..show();
            }
          });
        } else if (selectedValue == 1) {
          setState(() {
            print('object1');
          });
        } else {
          setState(() {
            print('object3');
          });
        }

      //   if (selectedValue == 0) {
      //     print('0');
      //     if (result.length == 1) {
      //       print('1');
      //       setState(() {
      //         _dates = result;
      //         _Startdate = _Sformat.format(_dates[0]!);
      //         _datecontrollorStart.text = '${_Startdate} ';
      //         setState(() {
      //           load = false;
      //         });
      //       });
      //     } else {
      //       print('2');
      //       setState(() {
      //         _dates = result;
      //         var _difference = _dates[1]!.difference(_dates[0]!).inDays + 1;
      //         //  _diff = _difference.inDays+1;
      //         ///////////////////////////////////////////////////////// ทำเรื่องการลา /////////////////////////////////////////////
      //         if (_difference > 2 && selecteStr == 'ลากิจ') {
      //           _Startdate = _Sformat.format(_dates[0]!);
      //           _Enddate = _Sformat.format(_dates[1]!);
      //         } else if (_difference > 3 && selecteStr == 'ลากิจ') {
      //           print(_difference);
      //         } else {
      //           _Startdate = _Sformat.format(_dates[0]!);
      //           _Enddate = _Sformat.format(_dates[1]!);
      //           _datecontrollorStart.text = '${_Startdate}';
      //           _datecontrollorEnd.text = '${_Enddate}';
      //         }

      //         log((_difference).toString());
      //         setState(() {
      //           load = false;
      //         });
      //       });
      //     }
      //   }
      //   if (selectedValue == 1) {}
      // } else {
      //   return null;
      // }
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
        calendarType: CalendarDatePicker2Type.range,
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
      print(result);
      if (result != null) {
        // if (result.length < 0) {
        _timeEnd = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        print('T${_timeEnd}');
        // } else {
        //   AwesomeDialog(
        //     context: context,
        //     animType: AnimType.scale,
        //     dialogType: DialogType.warning,
        //     title: 'การแจ้งเตือน',
        //     titleTextStyle:
        //         TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        //     desc: 'ลากิจได้ไม่เกิน 4 วัน\n รวมเสาร์-อาทิต นะคะ',
        //     btnOkOnPress: () {},
        //     dismissOnBackKeyPress: false,
        //     dismissOnTouchOutside: false,
        //   )..show();
        // }
      }
    });
  }

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
                  Container(
                    // height: 40,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          _DropDown(context),
                          SizedBox(
                            height: 10,
                          ),
                          selectedValue != null
                              ? Material(
                                  color: Colors.white,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(8),
                                  child: TextFormField(
                                    onTap: () async {
                                      await _date();
                                      TimeOfDay timeOfDay = await _time;
                                      setState(() {
                                        print(timeOfDay);
                                        _datecontrollorStart.text =
                                            '${_Startdate} ${timeOfDay.format(context)}';
                                        // if (_Enddate.toString() == null) {
                                          
                                          _datecontrollorEnd.text =
                                              '${_Enddate} ${timeOfDay.format(context)}';
//                                         } else {
//                                           print('E ${_Enddate}');
//                                           // print(_datecontrollorEnd.text);
// // _datecontrollorEnd.text = '${_Enddate}  ${timeOfDay.format(context)}';
//                                         }
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
                                          'Request leave.Choose a time period'
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
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          selectedValue != null
                              ? Material(
                                  color: Colors.white,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(8),
                                  child: TextFormField(
                                    onTap: () async {
                                      await datefill2();
                                      TimeOfDay timeOfDay = await _timeEnd;
                                      _datecontrollorStart.text = '${_Startdate} ${timeOfDay.format(context)}';
                                      if (_datecontrollorEnd.text.isEmpty) {
                                        _datecontrollorEnd.text =
                                            '${_Enddate} 17:30';
                                      } else {
                                        _datecontrollorEnd.text =
                                            '${_Enddate} ${timeOfDay.format(context)}';
                                      }
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
                                          'Request leave.Choose a time period'
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
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          selectedValue != null
                              ? Column(
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
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                        maxLines: 4, // รับข้อความหลายบรรทัด
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 15,
                          ),
                          selectedValue != null
                              ? Row(
                                  children: [
                                    Text('Request leave.AddImage').tr(),
                                    imagePath != null
                                        ? IconButton(
                                            onPressed: () => _pickImage(),
                                            icon: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 20,
                                              color: Colors.blue,
                                            ),
                                          )
                                        : Container()
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 5,
                          ),
                          imagePath != null
                              ? Container(
                                  color: Colors.white,
                                  // width: 280,
                                  // height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: showImage(),
                                  ),
                                )
                              : selectedValue != null
                                  ? ElevatedButton.icon(
                                      onPressed: () => _pickImage(),
                                      icon: Icon(
                                          Icons.add_photo_alternate_outlined),
                                      label:
                                          Text('Request leave.AddImage').tr(),
                                    )
                                  : Container()

                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       Text('Request leave.list').tr(),
                          //       SizedBox(height: 5),
                          //       Card(
                          //         child: Container(
                          //             width: double.infinity, child: Text('data').tr()),
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Buttons(title: 'Request leave.Save'.tr(), press: () {}),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget _DropDown(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              'Request leave.select',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ).tr(),
            items: _item
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selecteStr,
            onChanged: (value) {
              setState(() {
                selectedValue = _item.indexOf(value);
                selecteStr = value.toString();
                print(selecteStr!);
                print(selectedValue.toString());
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              // height: 40,
              width: 140,
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
                // height: 40,
                ),
          ),
        ),
      ),
    );
  }
}
