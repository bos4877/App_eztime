// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class improve_uptime extends StatefulWidget {
  const improve_uptime({super.key});

  @override
  State<improve_uptime> createState() => _improve_uptimeState();
}

class _improve_uptimeState extends State<improve_uptime> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _description = TextEditingController();
  var _time;
  var _date;
  var _getToken;
  var _Startdate;
  var timeOfDay__datefill;
  bool loading = false;
  List<DateTime?> _dates = [];

  TextEditingController _datecontrollorStart = TextEditingController();

  _refreshlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = prefs.getString('_acessToken');
  }
  Future add_time(String dateS, String time, String desc) async {
    setState(() {
      loading = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        String url = '${connect_api().domain}/add_time_check';
        var response = await Dio().post(url,
            data: {"date": '$_dates', "time": "$time", "description": "$desc"},
            options: Options(headers: {'Authorization': 'Bearer $_getToken'}));
        if (response.statusCode == 200) {
          Dialog_Tang().approveSuccessdialog(context);
          Navigator.pop(context);
        } else {
          log(response.statusCode.toString());
          Dialog_Tang().falsedialog(context);
        }
      } else {}
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
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

  @override
  void initState() {
    _refreshlogin();
    InternetConnectionChecker().checker();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Improve Uptime.title').tr(),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.35,
              vertical: MediaQuery.of(context).size.height * 0.05),
          child: Buttons(
              title: 'Get approval, Ot.Save'.tr(),
              press: () async {
                var time = timeOfDay__datefill
                    .toString()
                    .split('(')
                    .last
                    .split(')')
                    .first;
                add_time(_Startdate.toString(), time, _description.text);
              })),
      body: Form(
        key: _formkey,
        child: Container(
          padding: const EdgeInsets.all(20),
          // alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Improve Uptime.Date').tr(),
              // Text('Improve Uptime.Status').tr(),
              // Text('Improve Uptime.working time').tr(),
              // Text('รหัสพนักงาน ชื่อ-สกุล'),
              SizedBox(
                height: 20,
              ),
                 TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                    return 'กรุณากรอกวันที่';
                    }
                    return null;
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

                  style: TextStyle(color: Colors.black), // สีของข้อความ
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue,style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                  
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                    hintText: 'Request leave.Start Choose a time period'.tr(),
                    hintStyle:
                        TextStyle(color: Colors.grey), // สีข้อความในฮินท์
                    prefixIcon: Icon(Icons.calendar_month, color: Colors.blue),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _datecontrollorStart.clear();
                        setState(() {
                          _dates = [];
                        });
                      },
                      icon: Icon(Icons.highlight_remove_outlined,
                          color: _datecontrollorStart.text.isEmpty
                              ? Colors.white
                              : Colors.blue),
                    ), // สีไอคอน
                    filled: true,
                    fillColor: Colors.white, // สีพื้นหลัง
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(style: BorderStyle.solid,), // ไม่มีเส้นขอบ
                    ),
                  ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text('รายละเอียด'),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: Colors.white,
                    // elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue,style: BorderStyle.solid),
                        ),
                          contentPadding: EdgeInsets.all(6),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,style: BorderStyle.solid),
                          )),
                      maxLines: 4, // รับข้อความหลายบรรทัด
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
