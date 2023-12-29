// ignore_for_file: unnecessary_null_comparison, unused_import, unused_local_variable, unused_field
import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
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
  var _Fisttime;
  var _Endtime;
  List _datadate = [];
  var resule1;
  var _fordate;
  var _for1date;

  @override
  void initState() {
      InternetConnectionChecker().checker();
    super.initState();
  }

  Future _Stime(BuildContext context) async {
    _Fisttime = showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 08:00:00.000')),
    );
    if (_Fisttime != null) {
      return _Fisttime;
    } else {
      print('No Selected');
    }
  }
    Future _Etime(BuildContext context) async {
    _Endtime = showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
    );
    if (_Endtime != null) {
      return _Endtime;
    } else {
      print('No Selected');
    }
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
    ).then((resule1) {
      if (resule1 != null) {
        // var _dates = DateTime.now();
        if (resule1.isNotEmpty) {
          print(resule1);

          var _formatedate = resule1.toString();
          _fordate =
              _formatedate.split('[').last.split(']').first.split(' ').first;
          // var _formatetime = _Fisttime.toString();
          // var _foetime = _formatetime.split('(').last.split(')').first;
          // _datadate = ['${_fordate}', '${_Fisttime}'];
          print(_datadate);
          if (_Fisttime == null || _fordate == null) {
            setState(() {
              _dateFil1controlor.clear();
              _cleariconfile1 = false;
            });
          } else {
            setState(() {
              // _dateFil1controlor.text = '${_fordate} ${_foetime}';
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
    var resule2 = await showCalendarDatePicker2Dialog(
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
    ).then((_date) {
      if (_date != null) {
        _Endtime = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var _formatedate = _date.toString();
        _for1date = _formatedate.split(' ').first;
        var _formatetime = _Endtime.toString();
        var _for1time = _formatetime.split('(').last.split(')').first;

        if (_Endtime == null || _date == null) {
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
      bottomNavigationBar: _dateFil1controlor.text != null
          ? null
          : Container(
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
                  onTap: () async {
                    await _dateFil1();
                    final TimeOfDay? pickedTime = await _Stime(context);
                    TimeOfDay endtime = TimeOfDay.fromDateTime(
                        DateTime.parse('2023-08-23 17:30:00.000'));
                    if (pickedTime == '') {
                      setState(() {
                        _dateFil1controlor.clear();
                      });
                    } else {
                      setState(() {
                        if (pickedTime == null) {
                          setState(() {
                            _dateFil1controlor.text = '';
                          });
                        } else {
                          _dateFil1controlor.text =
                              '${_fordate} ${pickedTime.format(context)}';
                        }
                      });
                    }
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
                        onTap: () async {
                          await _dateFil2();
                        final  TimeOfDay _timeofday = await _Etime(context);
                          if (_timeofday != null) {
                      _dateFil2controlor.text = '${_Endtime} ${_timeofday.format(context)}';
                          }
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
                      child: Column(children: []),
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
