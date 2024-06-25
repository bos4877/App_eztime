// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class request_edit_uptime extends StatefulWidget {
  const request_edit_uptime({super.key});

  @override
  State<request_edit_uptime> createState() => _request_edit_uptimeState();
}

class _request_edit_uptimeState extends State<request_edit_uptime> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController annotation = TextEditingController();
  var _time;
  var _Startdate;
  var _getToken;
  var _Starttime;
  TimeOfDay? timeOfDay__startdate;
  bool loading = false;
  List<Data> _addtime = [];
  int _addtimeCount = 0;
  List<DateTime?> _dates = [];

  TextEditingController _datecontrollorStart = TextEditingController();
  Future getaddtime() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _getToken = prefs.getString('_acessToken');
      var get_addtime = await get_addtime_list_Service().model(_getToken);
      _addtime = get_addtime;
      int countaddtimeW =
          _addtime.where((adtime) => adtime.status == 'waiting').length;
      _addtimeCount = countaddtimeW;
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future add_time(String dateS, String desc) async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _getToken = prefs.getString('_acessToken');
      if (_formkey.currentState!.validate()) {
        String url = '${connect_api().domain}/create_addtimedoc';
        var response = await Dio().post(url,
            data: {"shift_date": '$dateS', "description": "$desc"},
            options: Options(headers: {'Authorization': 'Bearer $_getToken'}));
        if (response.statusCode == 200) {
          log(response.statusCode.toString());
          Dialog_Success.showCustomDialog(context);
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
        } else {
          log(response.statusCode.toString());
          Dialog_false.showCustomDialog(context);
        }
      } else {}
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getaddtime();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
                bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.35,
                        vertical: MediaQuery.of(context).size.height * 0.05),
                    child: Buttons(
                        title: 'buttons.Save'.tr(),
                        press: () async {
                          if (_formkey.currentState!.validate()) {
                            var time = timeOfDay__startdate
                                .toString()
                                .split('(')
                                .last
                                .split(')')
                                .first;
                            add_time(
                                _datecontrollorStart.text, annotation.text);
                          } else {
                            Dialog_date_alert().showCustomDialog(context);
                          }
                        })),
                body: Form(
                        key: _formkey,
                        child: Stack(
                          children: [
                            MyAppBar(pagename: 'Improve_Uptime.title'),
                            Container(
                              padding: EdgeInsets.only(
                                  top: size * 0.23, left: 16, right: 16),
                              child: _buildDatePicker(
                                'From',
                                _datecontrollorStart.text,
                                () async {
                                  await _startdate();
                                  timeOfDay__startdate = await _Starttime;
                                  setState(() {
                                    print(timeOfDay__startdate);
                                    if (timeOfDay__startdate == null) {
                                      Dialog_date_alert().showCustomDialog(context);
                                    } else {
                                      _datecontrollorStart.text =
                                          '${_Startdate} ${timeOfDay__startdate!.format(context)}';
                                    }
                                  });
                                },
                                _datecontrollorStart,
                                (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกวันที่';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: size * 0.36, left: 16, right: 16),
                                child: _buildDetailApplicationForm()),
                          ],
                        ),
                      ),
              ),
              loading
        ? LoadingComponent()
        : SizedBox()
      ],
    );
  }

  Widget _buildDetailApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('หมายเหตุ '),
            Text(
              '*',
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: annotation,
          decoration: InputDecoration(
            hintText: 'edit_uptime.note'.tr(),
            border: UnderlineInputBorder(),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'edit_uptime.error'.tr();
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, String date, VoidCallback pres,
      TextEditingController contro, FormFieldValidator validat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        TextFormField(
          controller: contro,
          onTap: pres,
          readOnly: true,
          decoration: InputDecoration(
            hintText: date.isEmpty ? 'เลือกวันที่' : date,
            border: UnderlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
          validator: validat,
        ),
      ],
    );
  }

  Future _startdate() async {
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
          _Starttime = showTimePicker(
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
          _Starttime = showTimePicker(
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
}
