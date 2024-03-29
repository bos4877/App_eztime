// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/calendar_holiday/calendar_holiday_Model.dart'
    as event;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month -12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month +12, kToday.day);

class working_time_Page extends StatefulWidget {
  @override
  _working_time_PageState createState() => _working_time_PageState();
}

class _working_time_PageState extends State<working_time_Page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  bool loading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? token;
  List<event.Data> _listEVent = [];
  SharedPrefe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    fetchEventsFromApi(token);
  }

  Future fetchEventsFromApi(token) async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/get_event_calendar';
      // สมมติว่าคุณใช้ http package เพื่อดึงข้อมูลจาก API
      final response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        event.calendar_holiday_Model json =
            event.calendar_holiday_Model.fromJson(response.data);
        _listEVent = json.data!;
      } else {
        Dialog_notdata.showCustomDialog(context);
        throw Exception('Failed to load events from API');
        
      }
    } catch (e) {
      //Dialog_internetError.showCustomDialog(context);
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  @override
  void initState() {
    SharedPrefe();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('Manage_time.working_time'.tr()),
            ),
            body: Column(
              children: [
              TableCalendar(
                availableCalendarFormats: {CalendarFormat.month: 'Month'},
                daysOfWeekHeight: 30,
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                weekendDays: [DateTime.saturday, DateTime.sunday],
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                    weekendTextStyle: TextStyle(color: Colors.red),
                    holidayTextStyle: TextStyle(color: Colors.red),
                    outsideDaysVisible: false),
                onDaySelected: _onDaySelected,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, opject) {
                    String date = '$day'.split(' ').first;
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _listEVent.length,
                        itemBuilder: (context, index) {
                          return _listEVent[index].date == date
                              ? Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 8,
                                  ),
                                )
                              : Container();
                        });
                  },
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
              ),
              SizedBox(height: 8.0),
              Expanded(
                  child: ListView.builder(
                itemCount: _listEVent.length,
                itemBuilder: (context, index) {
                  String date = '$_focusedDay'.split(' ').first;
                  
                  return _listEVent[index].date == date
                      ? Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            // onTap: () => print('${value[index].title}'),
                            title: Text('${_listEVent[index].holidayName}'),
                          ),
                        )
                      : Container();
                },
              ))
            ]));
  }
}
