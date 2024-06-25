// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/calendar_holiday/get_work_time.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);

class working_time_Page extends StatefulWidget {
  @override
  _working_time_PageState createState() => _working_time_PageState();
}

class _working_time_PageState extends State<working_time_Page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  bool loading = false;
  bool loadmount = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int? _selectedMonth;
  List<String> _months = DateFormat.MMMM().dateSymbols.MONTHS.toList();
  int _selectedYear = DateTime.now().year;
  // var mounText;
  String? token;
  List<Data> _listEVent = [];
  SharedPrefe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    fetchEventsFromApi(token);
  }

  String formatMonth(String month) {
    return month.padLeft(2, '0');
  }

  Future fetchEventsFromApi(token) async {
    setState(() {
      loadmount = true;
    });
    var _mon = _selectedMonth.toString();
    var formate = formatMonth(_mon);
    try {
      String url = '${connect_api().domain}/GetCalendar_Year_Month';
      // สมมติว่าคุณใช้ http package เพื่อดึงข้อมูลจาก API
      final response = await Dio().post(url,
          data: {"month": "$formate", "year": "$_selectedYear"},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_worktime_model json = get_worktime_model.fromJson(response.data);
        _listEVent = json.data!;
      } else {
        Dialog_notdata.showCustomDialog(context);
        throw Exception('Failed to load events from API');
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
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
    loadmount  = true;
    SharedPrefe();
    _selectedMonth = DateTime.now().month;
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
                pagename: 'Manage_time.working_time',
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
                        availableCalendarFormats: {
                          CalendarFormat.month: 'Month'
                        },
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
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _listEVent.length,
                                itemBuilder: (context, index) {
                                  var shiftdate = _listEVent[index]
                                      .shiftDate!
                                      .split('T')
                                      .first;
                                  var status = _listEVent[index].isweekend;
                                  return shiftdate == date && status == false
                                      ? Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.circle,
                                            color: Colors.red,
                                            size: 6,
                                          ),
                                        )
                                      : Container();
                                });
                          },
                        ),
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                          _selectedMonth = focusedDay.month.toInt();
                          fetchEventsFromApi(token);
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
                          var shiftdate =
                              _listEVent[index].shiftDate!.split('T').first;
                          return shiftdate == date
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.orange,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
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
                                    title: shift_date_data(
                                      des: '${_listEVent[index].description}',
                                      strat: '${_listEVent[index].start}',
                                      end: '${_listEVent[index].end}',
                                    ),
                                  ),
                                )
                              : SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }
}

class shift_date_data extends StatelessWidget {
  String des;
  String strat;
  String end;
  shift_date_data(
      {super.key, required this.des, required this.strat, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('status: '),
            Text(
              '${des}',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        Row(
          children: [
            Text('เริ่ม: '),
            Text('${strat}'),
          ],
        ),
        Row(
          children: [
            Text('สิ้นสุด: '),
            Text('${end}'),
          ],
        ),
      ],
    );
  }
}
