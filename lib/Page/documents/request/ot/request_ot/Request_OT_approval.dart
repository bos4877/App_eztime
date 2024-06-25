// ignore_for_file: unnecessary_null_comparison, unused_import, unused_local_variable, unused_field
import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DropDownWidget/DropDown_CM.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart'
    as doclist;
import 'package:eztime_app/Model/Get_Model/Ot/get_ot/get_Ot_Model.dart';
import 'package:eztime_app/Page/documents/logRequest/request_ot.dart';
import 'package:eztime_app/Page/documents/request/ot/Edite_ot/Edite_ot.dart';
import 'package:eztime_app/Page/documents/request/ot/tapbar_logrequest_ot.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_Ot_service.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:flutter/material.dart';
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
  bool loading = false;
  bool _cleariconfile1 = false;
  bool _cleariconfile2 = false;
  String? selecteStr;
  int? selectedValue;
  List<doclist.Data> docList = [];
  List<DateTime?> _dates = [];
  TimeOfDay? timeOfDay__datefill;
  TimeOfDay? timeOfDay_datefill2;
  int notificationCount = 0;

  ///--------------------------------------------------------------------------------------------------------------------------
  bool readOnly = true;
  bool showResetIcon = true;
  List<Data> _otdata = [];
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
    SharedPrefs();
    super.initState();
  }

  SharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    log(token);
    _get_ot();
  }

  Future ad_ot(ot_id, startDate, endDate, description, shift_date) async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/add_ot_doc';
      var response = await Dio().post(url,
          data: {
            "ot_id": "$ot_id",
            "start_date": "$startDate",
            "end_date": "$endDate",
            "description": "$description",
            "shift_date": "$shift_date"
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      log(response.data.toString());
      if (response.statusCode == 200) {
        loading = false;
        Dialog_Success.showCustomDialog(context);
      } else {
        Dialog_false.showCustomDialog(context);
        loading = false;
      }
    } catch (e) {
      //Dialog_internetError.showCustomDialog(context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future _get_ot() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await get_Ot_Service().model();
      var get_ot = await get_doc_Ot_list_one_Service().model(token,context);
      if (response is int) {
        log('message1: ${response}');
      } else {
        _otdata = response;
        for (var element in _otdata) {
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
        setState(() {
          loading = false;
        });

      }
    } catch (e) {
      // //Dialog_internetError.showCustomDialog(context);
      log(e.toString());
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
    ).then((result) {
      if (result != null && result.isNotEmpty) {
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

  bool _text_open_buttons = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('Get_approval_Ot.title').tr(),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Buttons(
                  title: 'buttons.Save'.tr(),
                  press: () {
                    var timefile1 = timeOfDay__datefill
                        .toString()
                        .split('(')
                        .last
                        .split(')')
                        .first;
                    var timefile2 = timeOfDay_datefill2
                        .toString()
                        .split('(')
                        .last
                        .split(')')
                        .first;
                    var start = '${_Startdate} ${timefile1}';
                    var enddates = '${_Enddate} ${timefile2}';
                    var shift_date = DateTime.now().toString();
                    ad_ot(otid, start, enddates, leaveDescription.text,
                        shift_date);
                  }),
            ),
            body: ListView(
              padding: EdgeInsets.all(8),
              children: [
                SizedBox(
                  height: 20,
                ),
                Drop_Down(
                  title: 'Get_approval_Ot.selectOt',
                  item: _item,
                  value: selecteStr,
                  onChang: (p0) {
                    setState(() {
                      selectedValue = _item.indexOf(p0);
                      var sucessValue = selectedValue! + 1;
                      selecteStr = p0.toString();
                      var _laeveId = _item[selectedValue!];
                      otid = _otdata[selectedValue!].value;
                      log(_laeveId.toString());
                      log(otid.toString());
                    });
                  },
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        // color: Colors.white,
                        borderOnForeground: false,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          onTap: () async {
                            await _datefill();
                            timeOfDay__datefill = await _time;
                            setState(() {
                              print(timeOfDay__datefill);
                              if (timeOfDay__datefill == null) {
                                Dialog_date_alert().showCustomDialog(context);
                              } else {
                                _datecontrollorStart.text =
                                    '${_Startdate} ${timeOfDay__datefill == null ? '08:00' : timeOfDay__datefill!.format(context)}';
                              }
                            });
                          },
                          controller: _datecontrollorStart,
                          readOnly: true,
                          style: TextStyle(color: Colors.black), // สีของข้อความ
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(
                                8), // ระยะห่างระหว่างข้อความและขอบ
                            hintText: 'Get_approval_Ot.Choose start time'.tr(),
                            hintStyle: TextStyle(
                                color: Colors.grey), // สีข้อความในฮินท์
                            prefixIcon: Icon(Icons.calendar_month,
                                color: Theme.of(context).primaryColor),
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
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                            ), // สีไอคอน
                            filled: true,
                            fillColor: Colors.white, // สีพื้นหลัง
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        color: Colors.white,
                        borderOnForeground: false,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          onTap: () async {
                            await datefill2();
                            timeOfDay_datefill2 = await _timeEnd;
                            setState(() {
                              print(timeOfDay_datefill2);
                              if (timeOfDay__datefill == null) {
                                Dialog_date_alert().showCustomDialog(context);
                              } else {
                                _datecontrollorEnd.text =
                                    '${_Enddate} ${timeOfDay__datefill == null ? '17:30' : timeOfDay_datefill2?.format(context).split('TimeOfDay').last.split("(").last.split(')').first}';
                              }
                            });
                          },
                          controller: _datecontrollorEnd,
                          readOnly: true,
                          style: TextStyle(color: Colors.black), // สีของข้อความ
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(
                                8), // ระยะห่างระหว่างข้อความและขอบ
                            hintText:
                                'Get_approval_Ot.Choose the end period'.tr(),
                            hintStyle: TextStyle(
                                color: Colors.grey), // สีข้อความในฮินท์
                            prefixIcon: Icon(Icons.calendar_month,
                                color: Theme.of(context).primaryColor),
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
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                            ), // สีไอคอน
                            filled: true,
                            fillColor: Colors.white, // สีพื้นหลัง
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request_leave.Details',
                            style: TextStyle(decorationThickness: 5),
                          ).tr(),
                          SizedBox(
                            height: 5,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(8),
                            child: TextFormField(
                              controller: leaveDescription,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(6),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              maxLines: 4, // รับข้อความหลายบรรทัด
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
