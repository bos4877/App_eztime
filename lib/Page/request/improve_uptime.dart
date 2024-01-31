// ignore_for_file: unused_local_variable

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';

class improve_uptime extends StatefulWidget {
  const improve_uptime({super.key});

  @override
  State<improve_uptime> createState() => _improve_uptimeState();
}

class _improve_uptimeState extends State<improve_uptime> {
  var _time;
  var _date;
  List<DateTime?> _dates = [];
  var _getToken;
  TextEditingController _controller = TextEditingController();

_refreshlogin()async{
       _getToken = await LoginApiService().fetchData();
}

  Future date() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.range,
        dayTextStyle: TextStyle(),
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        selectedDayHighlightColor: Colors.blue,
        closeDialogOnOkTapped: true,
        centerAlignModePicker: true,
        firstDate: DateTime.now().subtract(Duration(days: 7)),
      ),
      dialogBackgroundColor: Colors.white,
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    ).then((result) {
      print(result);
      if (result != null) {
        print(result);
        _time = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 08:00:00.000')),
        );
        print(_dates);
        if (_time != null) {
          setState(() {
            _date = result;
            print(_date);
            // var _dataformat = DateFormat.yMMMMd().format(_date[0]);

            // _controller.text = '${_dataformat} ${_time.hour}:${_time.minute}';
          });
        } else {
          print('Error1233545');
        }
      } else {
        print('Error');
      }
    });
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
    return  Scaffold(
      appBar: AppBar(
        title: Text('Improve Uptime.title').tr(),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Improve Uptime.Date').tr(),
                Text('Improve Uptime.Status').tr(),
                Text('Improve Uptime.working time').tr(),
                SizedBox(
                  height: 10,
                ),
                Text('รหัสพนักงาน ชื่อ-สกุล'),
                Material(
                  color: Colors.white,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                  child: TextFormField(
                    onTap: () async {
                      await date();
                      TimeOfDay timeOfDay = await _time;
                      
                      setState(() {
                        var _datectlFm = DateFormat('dd-MM-y')
                            .format(_date[0])
                            .split('[')
                            .last
                            .split('00')
                            .first;
                        _controller.text = '${_datectlFm} ${timeOfDay.format(context)}';
                      });
                    },
                    controller: _controller,
                    readOnly: true,
                    style: TextStyle(color: Colors.black), // สีของข้อความ
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0), // ระยะห่างระหว่างข้อความและขอบ
                      hintText: 'Request leave.Choose a time period'.tr(),
                      hintStyle:
                          TextStyle(color: Colors.grey), // สีข้อความในฮินท์
                      prefixIcon:
                          Icon(Icons.calendar_month, color: Colors.blue),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            // _dates = [];
                          });
                        },
                        icon: Icon(Icons.highlight_remove_outlined,
                            color: Colors.blue),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
