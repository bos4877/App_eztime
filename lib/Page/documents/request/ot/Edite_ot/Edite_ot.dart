import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_ot/get_Ot_Model.dart';
import 'package:eztime_app/controller/APIServices/ot_service/get_Ot_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_ot_page extends StatefulWidget {
  final docid;
  final desc;
  final ottype;
  final otvalue;
  final startdate;
  final enddate;
  final shipdate;
  const Edit_ot_page(
      {super.key,
      this.docid,
      this.desc,
      this.ottype,
      this.startdate,
      this.enddate,
      this.shipdate,
      this.otvalue});

  @override
  State<Edit_ot_page> createState() => _Edit_ot_pageState();
}

class _Edit_ot_pageState extends State<Edit_ot_page> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  var shipdate;
  var token;
  var _Endtime;
  var _Startdate;
  var _Enddate;
  var _Starttime;
  List _item = [];
  List<Data> _otList = [];
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController otDescription = TextEditingController();
  TimeOfDay? timeOfDay__startdate;
  TimeOfDay? timeOfDay_enddate;
  List<DateTime?> _dates = [];
  DateFormat _Sformat = DateFormat('dd-MM-y');
  String? select_ottype;
  String? selectedValue;
  var _otid;
  @override
  void initState() {
    getleave();
    _settext();
    // TODO: implement initState
    super.initState();
  }

  Future getleave() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    var service = get_Ot_Service();
    var response = await service.model();
    //
    if (response == null) {
      log('getotfaile');
      setState(() {
        loading = false;
      });
    } else {
      _otList = response;
      setState(() {
        loading = false;
      });
    }
  }

  Future _settext() async {
    var Stdate = widget.startdate.toString();
    var formateStdate = Stdate.split('T').first;
    var Eddate = widget.enddate.toString();
    var formateEddate = Eddate.split('T').first;
    shipdate = widget.shipdate;
    select_ottype = widget.ottype;
    _otid = widget.otvalue;
    _datecontrollorStart = await TextEditingController(text: formateStdate);
    _datecontrollorEnd = await TextEditingController(text: formateEddate);
    select_ottype = widget.ottype.toString();
    otDescription = await TextEditingController(text: widget.desc);
  }

  Future edite() async {
    try {
      String url = '${connect_api().domain}/edit_doc_ot_details_user';
      var response = await Dio().post(url,
          data: {
            "doc_id": widget.docid.toString(),
            "description": otDescription.text,
            "start_date": _datecontrollorStart.text,
            "end_date": _datecontrollorEnd.text,
            "ot_type": _otid,
            "shift_date": shipdate
          },
          options: Options(headers: {'Authorization': 'Bearer ${token}'}));
      if (response.statusCode == 200) {
        success_dialog(detail: 'edit_ot.success',).show(context);
        return response.statusCode;
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      false_dialog(detail: '${message}',).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('edit_ot.title'.tr()),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                  vertical: MediaQuery.of(context).size.height * 0.04),
              child: Buttons(
                  title: 'buttons.Save'.tr(),
                  press: () async {
                    edite();
                  }),
            ),
            body: loading
                ? LoadingComponent()
                : Form(
                    key: _formkey,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              'edit_ot.subtitle'.tr(),
                            ),
                            Container(
                              height: 150,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _otList.map((ot) {
                                    return _buildLeaveBalanceCard(
                                        ot.label!, ot.value!
                                        );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('edit_ot.select_clock'.tr(),
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDatePicker('From',
                                          '${_datecontrollorStart.text}',
                                          () async {
                                        await _startdate();
                                        timeOfDay__startdate = await _Starttime;
                                        setState(() {
                                          print(timeOfDay__startdate);
                                          if (timeOfDay__startdate == null) {
                                            Dialog_date_alert()
                                                .showCustomDialog(context);
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
                                          'To', '${_datecontrollorEnd.text}',
                                          () async {
                                        await enddate();
                                        timeOfDay_enddate = await _Endtime;
                                        setState(() {
                                          print(timeOfDay_enddate);
                                          if (timeOfDay_enddate == null) {
                                            Dialog_date_alert()
                                                .showCustomDialog(context);
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
          );
  }

  Widget _buildStatusCircle(String label, String count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(count, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaveBalanceCard(
      String label,
      // String count,
      String leave_value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _otid = leave_value == _otid ? null : leave_value;
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
                  value: _otid == leave_value,
                  onChanged: (value) {
                    setState(() {
                      loading = true;
                      _otid = value! ? leave_value : null;
                      selectedValue = leave_value;
                      loading = false;
                      log('selectedValue: ${selectedValue}');
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
        Text('edit_ot.detail'.tr()),
        SizedBox(
          height: 10,
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: otDescription,
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
            hintText: date.isEmpty ? 'เลือกวันที่' : date,
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
