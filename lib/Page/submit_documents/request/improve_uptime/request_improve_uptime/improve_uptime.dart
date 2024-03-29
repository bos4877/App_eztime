// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Page/submit_documents/appeove/improve_uptime/tapbar_apporv_improve_uptime.dart';
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
  Future getaddtime() async {
    try {

    } catch (e) {}
  }

  Future add_time(String dateS,String desc) async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _getToken = prefs.getString('_acessToken');
      if (_formkey.currentState!.validate()) {
        String url = '${connect_api().domain}/create_addtimedoc';
        var response = await Dio().post(url,
            data: {"shift_date": '$dateS',"description": "$desc"},
            options: Options(headers: {'Authorization': 'Bearer $_getToken'}));
        if (response.statusCode == 200) {
          Dialog_save_Success.showCustomDialog(context);
          Navigator.pop(context);

        } else {
          log(response.statusCode.toString());
          Dialog_false.showCustomDialog(context);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Improve Uptime.title').tr(),
        actions: [
          loading
              ? Container()
              : badges.Badge(
                  position: badges.BadgePosition.topEnd(end: 8, top: 8),
                  badgeContent: Text(
                    'countLeaveW.toString()',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                tapbar_apporv_improve_uptime(),
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
              vertical: MediaQuery.of(context).size.height * 0.05),
          child: Buttons(
              title: 'Get approval, Ot.Save'.tr(),
              press: () async {
                if (_formkey.currentState!.validate()) {
                  var time = timeOfDay__datefill
                      .toString()
                      .split('(')
                      .last
                      .split(')')
                      .first;
                  add_time(_datecontrollorStart.text, _description.text);
                } else {
                  Dialog_date_alert().showCustomDialog(context);
                }
              })),
      body: loading
          ? LoadingComponent()
          : Form(
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
                          if (timeOfDay__datefill == null) {
                            Dialog_date_alert().showCustomDialog(context);
                          } else {
                            _datecontrollorStart.text =
                                '${_Startdate} ${timeOfDay__datefill.format(context)}';
                          }
                        });
                      },
                      controller: _datecontrollorStart,
                      readOnly: true,

                      style: TextStyle(color: Colors.black), // สีของข้อความ
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(6.0),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                        hintText:
                            'Request leave.Start Choose a time period'.tr(),
                        hintStyle:
                            TextStyle(color: Colors.grey), // สีข้อความในฮินท์
                        prefixIcon:
                            Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
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
                                  : Theme.of(context).primaryColor),
                        ), // สีไอคอน
                        filled: true,
                        fillColor: Colors.white, // สีพื้นหลัง
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                          ), // ไม่มีเส้นขอบ
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
                        TextFormField(
                          controller: _description,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    style: BorderStyle.solid),
                              ),
                              contentPadding: EdgeInsets.all(6),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    style: BorderStyle.solid),
                              )),
                          maxLines: 4, // รับข้อความหลายบรรทัด
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
