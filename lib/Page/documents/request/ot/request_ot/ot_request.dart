// ignore_for_file: unnecessary_null_comparison, unused_import, unused_local_variable, unused_field
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
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

class ot_request_page extends StatefulWidget {
  @override
  State<ot_request_page> createState() => _ot_request_pageState();
}

class _ot_request_pageState extends State<ot_request_page> {
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  bool loading = false;
  String? selectedotType;
  String? selectedValue;
  String? ot_value;
  List<Data> _otlist = [];
  List<DateTime?> _dates = [];
  TimeOfDay? timeOfDay__startdate;
  TimeOfDay? timeOfDay_enddate;
  final List<Map<String, dynamic>> daysData = [
    {'label': 'list_day.Sunday'.tr(), 'count': '4', 'color': Colors.red},
    {'label': 'list_day.Monday'.tr(), 'count': '5', 'color': Colors.yellow},
    {'label': 'list_day.Tuesday'.tr(), 'count': '3', 'color': Colors.pink},
    {'label': 'list_day.Wednesday'.tr(), 'count': '8', 'color': Colors.green},
    {'label': 'list_day.Thursday'.tr(), 'count': '2', 'color': Colors.orange},
    {'label': 'list_day.Friday'.tr(), 'count': '6', 'color': Colors.blue},
    {'label': 'list_day.Saturday'.tr(), 'count': '1', 'color': Colors.purple},
  ];

  ///--------------------------------------------------------------------------------------------------------------------------
  List _item = [];
  var _Startdate;
  var _Starttime;
  var _Endtime;
  var _timeEnd;
  var _Enddate;
  var token;
  var otid;
  var Language;
  @override
  void initState() {
    SharedPrefs();
    super.initState();
  }

  SharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    log(token);
    Language = await prefs.getString('selectedLanguage');
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
        success_dialog(
          detail: 'ot_request.success',
        ).show(context);
      } else {
        Dialog_false.showCustomDialog(context);
        loading = false;
      }
    } on DioError catch (e) {
      var error = e.message;
      debugPrint('e: $error');
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
        _otlist = response;
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

  @override
  Widget build(BuildContext context) {
    String today = DateFormat(
      'EEEE',
    ).format(DateTime.now());
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('ot_request.title'.tr()),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.35,
                vertical: MediaQuery.of(context).size.height * 0.05),
            child: Buttons(
                title: 'buttons.Save'.tr(),
                press: () {
                  var shift_date = DateTime.now().toString();
                  ad_ot(
                      otid,
                      _datecontrollorStart.text,
                      _datecontrollorEnd.text,
                      leaveDescription.text,
                      shift_date);
                }),
          ),
          body: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16, top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Status
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: daysData.map((day) {
                        bool isToday = day['label'] == today ? true : false;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Adjust the value as needed
                          child: _buildStatusCircle(day['label'], day['count'],
                              day['color'], isToday),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Leave Balance
                  Text(
                    'ot_request.selectOt'.tr(),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 150, // กำหนดความสูงให้ Container
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _otlist.map((otlist) {
                          return _buildLeaveBalanceCard(
                            otlist.label!,
                            otlist.value!,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ot_request.Choose'.tr(),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                                'From', '${_datecontrollorStart.text}',
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
                            }, _datecontrollorStart),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildDatePicker(
                                'To', '${_datecontrollorEnd.text}', () async {
                              await enddate();
                              timeOfDay_enddate = await _Endtime;
                              setState(() {
                                if (timeOfDay_enddate == null) {
                                  Dialog_date_alert().showCustomDialog(context);
                                } else {
                                  _datecontrollorEnd.text =
                                      '${_Enddate} ${timeOfDay_enddate?.format(context)}';
                                }
                              });
                            }, _datecontrollorEnd),
                          ),
                        ],
                      ),
                      _buildLeaveApplicationForm(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }

  Widget _buildStatusCircle(
      String label, String count, Color color, bool isToday) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(style: BorderStyle.none),
            color: color,
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: color,
                      offset: Offset(0, 3), // vertical offset
                      blurRadius: 9,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: CircleAvatar(
            radius: 20, // Increase radius for better visibility
            backgroundColor: Colors
                .transparent, // Set background to transparent as color is in BoxDecoration
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaveBalanceCard(String label, String otvalue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          otid = otvalue;
          selectedotType = otvalue == selectedotType ? null : otvalue;
        });
      },
      child: Container(
        width: 130, // กำหนดความกว้างให้ Container
        height: 120,
        margin: EdgeInsets.only(right: 8), // เพิ่ม margin ระหว่างการ์ดแต่ละใบ
        child: Card(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  fillColor: MaterialStatePropertyAll(Colors.white),
                  value: selectedotType == otvalue,
                  onChanged: (value) {
                    setState(() {
                      loading = true;
                      selectedotType = value! ? otvalue : null;
                      selectedValue = otvalue;
                      otid = selectedValue;
                      debugPrint('otvalue: ${otvalue}');
                      debugPrint('selectedValue: ${selectedValue}');
                      loading = false;

                      // _quotaleave[]
                    });
                  },
                ),
                Text(
                  '$label',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildLeaveApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text('ot_request.detail'.tr()),
        SizedBox(
          height: 10,
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: leaveDescription,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                )),
            maxLines: 4,
          ),
          // รับข้อความหลายบรรทัด
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, String date, VoidCallback pres,
      TextEditingController contro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        TextField(
          controller: contro,
          onTap: pres,
          readOnly: true,
          decoration: InputDecoration(
            hintText: date.isEmpty ? 'ot_request.Choose_a_day'.tr() : date,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
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

  Future enddate() async {
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
        _Endtime = showTimePicker(
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
        _Endtime = showTimePicker(
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
}
