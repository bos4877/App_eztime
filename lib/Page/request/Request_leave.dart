// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:developer';
import 'package:any_animated_button/any_animated_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/load/loaddialog.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class Request_leave extends StatefulWidget {
  const Request_leave({super.key});

  @override
  State<Request_leave> createState() => _Request_leaveState();
}

class _Request_leaveState extends State<Request_leave> {
  TextEditingController _datecontrolor = TextEditingController();
  DateFormat _Sformat = DateFormat('yMMMd');

  List<DateTime?> _dates = [];
  var _Startdate;
  var _Enddate;
  DateTime _dayBuilder = DateTime.now();
  String? selecteStr;
  int? selectedValue;
  List _item = ['ลากิจ', 'ลาป่วย', 'ลาไม่รับเงิน'];
  var _diff;
  bool load = false;
  var _time;
  bool isWeekend = DateTime.now().weekday == DateTime.saturday ||
  DateTime.now().weekday == DateTime.sunday;

  @override
  void initState() {
    super.initState();
  }

  Future _date() async {
    setState(() {
      load = true;
    });
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
        if (result.length < 4) {
          _time = showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                DateTime.parse('2023-08-23 08:00:00.000')),
          );
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

        if (selectedValue == 0) {
          if (result.length == 1) {
            setState(() {
              _dates = result;
              _Startdate = _Sformat.format(_dates[0]!);
              _datecontrolor.text = '${_Startdate} ';
              setState(() {
                load = false;
              });
            });
          } else {
            setState(() {
              _dates = result;

              var _difference = _dates[1]!.difference(_dates[0]!).inDays + 1;
              //  _diff = _difference.inDays+1;

              ///////////////////////////////////////////////////////// ทำเรื่องการลา /////////////////////////////////////////////
              if (_difference > 3 && selecteStr == 'ลากิจ') {
              } else {
                _Startdate = _Sformat.format(_dates[0]!);
                _Enddate = _Sformat.format(_dates[1]!);
                _datecontrolor.text = '${_Startdate} ถึง ${_Enddate}';
              }

              log((_difference).toString());
              setState(() {
                load = false;
              });
            });
          }
        }
        if (selectedValue == 1) {}
      } else {
        return null;
        // setState(() {
        //   load = true;
        //   _dates = [];

        //   // log(result!.length.toString());
        //   log(result.toString());
        //   print('St : $_Startdate');
        //   print('ED : $_Enddate');
        // });
      }
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3,
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: Buttons(title: 'Request leave.Save'.tr(), press: () {}),
      ),
      body: Container(
        // height: 40,
        child: Padding(
          padding: EdgeInsets.all(8),
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
                        onTap: () {
                          _date();
                        },
                        controller: _datecontrolor,
                        readOnly: true,

                        style: TextStyle(color: Colors.black), // สีของข้อความ
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                          hintText: 'Request leave.Choose a time period'.tr(),
                          hintStyle:
                              TextStyle(color: Colors.grey), // สีข้อความในฮินท์
                          prefixIcon:
                              Icon(Icons.calendar_month, color: Colors.blue),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _datecontrolor.clear();
                              setState(() {
                                _dates = [];
                              });
                            },
                            icon: Icon(Icons.highlight_remove_outlined,
                                color: Colors.blue),
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
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Request leave.list').tr(),
                    SizedBox(height: 5),
                    Card(
                      child: Container(
                          width: double.infinity, child: Text('data').tr()),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
                log(selecteStr!);
                log(selectedValue.toString());
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              // height: 40,
              width: 140,
            ),
            menuItemStyleData: MenuItemStyleData(
                // height: 40,
                ),
          ),
        ),
      ),
    );
  }
}
