// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, camel_case_types, unused_import

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class View_OT_logs extends StatefulWidget {
  const View_OT_logs({super.key});

  @override
  State<View_OT_logs> createState() => _View_OT_logsState();
}

class _View_OT_logsState extends State<View_OT_logs> {
  DateTime _firstDate = DateTime.parse('2023-01-01');
  List<DateTime> _dates = [];
  List _datadate = [];
  DateTime? date;
  var results;
  var _sdate;
  var _getdate;
  DateFormat _getformat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  DateFormat _Sformat = DateFormat('yyyy-MM-dd HH:mm');
  TextEditingController dateStart = TextEditingController();

  Future calender() async {
    results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
         weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: TextStyle(color: Colors.grey.shade600,fontSize: 14),
        firstDayOfWeek: 0,
        lastDate: DateTime.now(),
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    );
    // _datadate = results;
    // print(_datadate);
    if (results != null) {
      _datadate = results;
      print(_datadate);
      if (_datadate.isNotEmpty) {
        if (_datadate.length < 2) {
          AwesomeDialog(
            animType: AnimType.scale,
            context: context,
            dialogType: DialogType.warning,
            titleTextStyle: TextStyles.dialogStyless,
            title: 'เเจ้งเตือน',
            desc: 'กรุณาเลือกวันที่ให้ถูกต้อง',
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            btnOkOnPress: () {},
          )..show();
        } else {
          setState(() {
            _sdate = _Sformat.format(_datadate[0]).split(' ').first;
            _getdate = _getformat.format(_datadate[1]).split('T').first;
            dateStart.text = ' ${_sdate} ถึง ${_getdate}';
          });
        }
      } else {
           AwesomeDialog(
            animType: AnimType.scale,
            context: context,
            dialogType: DialogType.warning,
            titleTextStyle: TextStyles.dialogStyless,
            title: 'เเจ้งเตือน',
            desc: 'กรุณาเลือกวันที่',
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            btnOkOnPress: () {},
          )..show();
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watch the Ot log.title').tr()),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('ชื่อผู้ใช้งาน'),
            Container(
              child: Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
                child: TextFormField(
                  onTap: () async {
                    await calender();
                    setState(() {
                      print('results : ${results}');
                    });
                  },
                  controller: dateStart,
                  readOnly: true,
                  style: TextStyle(color: Colors.black), // สีของข้อความ
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                    hintText: 'Watch the Ot log.Choose a time period'.tr(),
                    hintStyle:
                        TextStyle(color: Colors.grey), // สีข้อความในฮินท์
                    prefixIcon: IconButton(
                      onPressed: () {
                        // dateStart.clear();
                        // setState(() {
                        //   _dates = [];
                        // });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ), // สีไอคอน
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.white, // สีพื้นหลัง
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
