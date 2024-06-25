// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/calendar_holiday/calendar_holiday_Model.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  bool loading = false;
  bool loadmount = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? token;
  List<Data> _listEVent = [];
  SharedPrefe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    fetchEventsFromApi(token);
  }

  Future fetchEventsFromApi(token) async {
    setState(() {
      // loading = true;
      loadmount = true;
    });
    try {
      String url = '${connect_api().domain}/get_holiday_default';
      // สมมติว่าคุณใช้ http package เพื่อดึงข้อมูลจาก API
      final response = await Dio().post(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await Future.delayed(Duration(seconds: 1));
      if (response.statusCode == 200) {
        calendar_holiday_Model json =
            calendar_holiday_Model.fromJson(response.data);
        _listEVent = json.data!;
      } else {
        Dialog_notdata.showCustomDialog(context);
        throw Exception('Failed to load events from API');
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
        loadmount = false;
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
    loading = true;
    loadmount = true;
    SharedPrefe();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              MyAppBar(
                pagename: 'Annual_holidays.title',
              ),
               card_loading_CPN(
                loading: loadmount,
                chid: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(top: size * 0.2, left: 16, right: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TableCalendar(
                        headerStyle: HeaderStyle(titleCentered: true),
                        availableCalendarFormats: {CalendarFormat.month: 'Month'},
                        daysOfWeekHeight: 30,
                        firstDay: kFirstDay,
                        lastDay: kLastDay,
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_focusedDay, day),
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
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            weekendTextStyle: TextStyle(color: Colors.red),
                            holidayTextStyle: TextStyle(color: Colors.red),
                            outsideDaysVisible: false),
                        onDaySelected: _onDaySelected,
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, opject) {
                            String date = '$day'.split(' ').first;
                            return ListView.builder(
                                itemExtent: 0.01,
                                physics: NeverScrollableScrollPhysics(),
                                padding:  EdgeInsets.all(0),
                                itemCount: _listEVent.length,
                                itemBuilder: (context, index) {
                                  String data_date =
                                      _listEVent[index].date!.split('T').first;
                
                                  return data_date == date
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
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'กิจกรรม',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _listEVent.length,
                        itemBuilder: (context, index) {
                          String date = '$_focusedDay'.split(' ').first;
                          String data_date =
                              _listEVent[index].date!.split('T').first;
                          return data_date == date
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.orange,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    trailing: Icon(
                                      Bootstrap.person_workspace,
                                      color: Colors.deepOrange,
                                      size: 40,
                                    ),
                                    title:
                                        Text('${_listEVent[index].holidayName}'),
                                  ),
                                )
                              : Container(
                                  );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading
            ? LoadingComponent(
              )
            : SizedBox()
      ],
    );
  }
}
