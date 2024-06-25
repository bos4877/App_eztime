import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edite_improve_uptime_page extends StatefulWidget {
  final docid;
  final des;
  final time;
  const Edite_improve_uptime_page({super.key, this.docid, this.des, this.time});

  @override
  State<Edite_improve_uptime_page> createState() =>
      _Edite_improve_uptime_pageState();
}

class _Edite_improve_uptime_pageState extends State<Edite_improve_uptime_page> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController annotation = TextEditingController();
  var _Starttime;
  var _getToken;
  var _Startdate;
  var docid;
  var timeOfDay__datefill;
  bool loading = false;
  List<DateTime?> _dates = [];
  TimeOfDay? timeOfDay__startdate;
  TextEditingController _datecontrollorStart = TextEditingController();
  @override
  void initState() {
    super.initState();
    settext();
    shareprefs();
  }

  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = prefs.getString('_acessToken');
    await get_Device_token_service().model(_getToken);
  }

  Future settext() async {
    log(widget.docid.toString());
    docid = widget.docid;
    _datecontrollorStart = TextEditingController(text: widget.time);
    annotation = TextEditingController(text: widget.des);
  }

  Future _edite_improve_uptime() async {
    if (_formkey.currentState!.validate()) {
      debugPrint('${_datecontrollorStart.text}');
      try {
        String url = '${connect_api().domain}/edit_Doc_Addtime_details_user';
        var response = await Dio().post(url,
            data: {
              "doc_id": "$docid",
              "description": annotation.text,
              "shift_date": _datecontrollorStart.text
            },
            options:
                Options(headers: {'Authorization': 'Bearer ${_getToken}'}));
        if (response.statusCode == 200) {
          Dialog_Success.showCustomDialog(context);
        }
      } on DioError catch (e) {
        var data = e.response!.data.toString();
        var message = data.split(':').last.split('}').first;
        Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return loading
        ? LoadingComponent()
        : Scaffold(
            bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.35,
                    vertical: MediaQuery.of(context).size.height * 0.05),
                child: Buttons(
                    title: 'buttons.Save'.tr(),
                    press: () async {
                      _edite_improve_uptime();
                    })),
            body: loading
                ? LoadingComponent()
                : Form(
                    key: _formkey,
                    child: Stack(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyAppBar(pagename: 'edit_uptime.title'),
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
          );
  }

  Widget _buildDetailApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('edit_uptime.annotation'.tr()),
            Text(
              'edit_uptime.*'.tr(),
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
            hintText: 'ใส่หมายเหตุ',
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
