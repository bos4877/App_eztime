// ignore_for_file: unnecessary_null_comparison
import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Request_OT_approval extends StatefulWidget {
  const Request_OT_approval({super.key});

  @override
  State<Request_OT_approval> createState() => _Request_OT_approvalState();
}

class _Request_OT_approvalState extends State<Request_OT_approval> {
  TextEditingController _dateFil1controlor = TextEditingController();
  TextEditingController _dateFil2controlor = TextEditingController();
  bool load = false;
  bool _cleariconfile1 = false;
  bool _cleariconfile2 = false;

  ///--------------------------------------------------------------------------------------------------------------------------
  bool readOnly = true;
  bool showResetIcon = true;
  // DateTime? _dates;
  TimeOfDay? _time;
  List _datadate = [];
  var resule1;
  // String _dateTextFil2 ='17.30';

  @override
  void initState() {
    super.initState();
  }

  Future _dateFil1() async {
    resule1 = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        firstDayOfWeek: 0,
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: Size(325, 400),
      // value: _date,
      borderRadius: BorderRadius.circular(15),
    ).then((_date) async {
      if (_date != null) {
        resule1 = _date;
        var _dates = DateTime.now();
        if (_date.isEmpty) {
          resule1 = _dates;
          print(resule1);
        _time = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var _formatedate = resule1.toString();
        var _fordate =_formatedate.split('[').last.split(']').first.split(' ').first;
        var _formatetime = _time.toString();
        var _foetime = _formatetime.split('(').last.split(')').first;
        _datadate = ['${_date}', '${_time}'];
        print(_datadate);
        if (_time == null || _date == null) {
          setState(() {
            _dateFil1controlor.clear();
            _cleariconfile1 = false;
          });
        } else {
          setState(() {
            _dateFil1controlor.text = '${_fordate} ${_foetime}';
            _cleariconfile1 = true;
          });
        }
        }
        // return DateTimeField.combine(date, time);
      } else {
        return null;
      }
    });
    // print('resule1 : ${resule1}');
  }

  Future _dateFil2() async {
    var resule2 = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((_date) async {
      if (_date != null) {
        _time = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 00:00:00.000')),
        );
        var _formatedate = _date.toString();
        var _for1date = _formatedate.split(' ').first;
        var _formatetime = _time.toString();
        var _for1time = _formatetime.split('(').last.split(')').first;

        _datadate = ['${_for1date}', '${_for1time}'];

        if (_time == null || _date == null) {
          setState(() {
            _dateFil2controlor.clear();
            _cleariconfile2 = false;
          });
        } else {
          setState(() {
            _dateFil2controlor.text = '${_for1date} ${_for1time}';
            _cleariconfile2 = true;
          });
        }
        // return DateTimeField.combine(date, time);
      } else {
        return null;
      }
    });
    // print('resule2 : ${resule2}');
  }

  bool _text_open_buttons = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get approval, Ot.title').tr()),
      bottomNavigationBar:
         _dateFil1controlor.text != null? null:
          Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.35,
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: Buttons(
            title: 'Get approval, Ot.Save'.tr(),
            press: () {
              setState(() {
                _text_open_buttons = false;
              });
            }),
      ),
      body: Container(
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
                  onTap: () {
                    _dateFil1();
                  },
                  controller: _dateFil1controlor,
                  readOnly: true,
                  style: TextStyle(color: Colors.black), // สีของข้อความ
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                    hintText: 'Get approval, Ot.Choose start time'.tr(),
                    hintStyle:
                        TextStyle(color: Colors.blue), // สีข้อความในฮินท์
                    prefixIcon: Icon(Icons.calendar_month, color: Colors.blue),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _dateFil1controlor.clear();
                        setState(() {
                          _cleariconfile1 = false;
                          _text_open_buttons = false;
                        });
                      },
                      icon: Icon(Icons.highlight_remove_outlined,
                          color: _cleariconfile1 ? Colors.blue : Colors.white),
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
              _dateFil1controlor.text.isNotEmpty
                  ? Material(
                      color: Colors.white,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(8),
                      ///////////////////////////////////////////////////////////
                      child: TextFormField(
                        onTap: () {
                          _dateFil2();
                        },
                        controller: _dateFil2controlor,
                        readOnly: true,
                        style: TextStyle(color: Colors.black), // สีของข้อความ
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                          hintText:
                              'Get approval, Ot.Choose the end period'.tr(),
                          hintStyle:
                              TextStyle(color: Colors.blue), // สีข้อความในฮินท์
                          prefixIcon:
                              Icon(Icons.calendar_month, color: Colors.blue),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _dateFil2controlor.clear();
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
                      //////////////////////
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Request leave.Pending Items').tr(),
                    SizedBox(height: 5),
                    Card(
                      child: Column(
                         children: [
                          
                         ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
