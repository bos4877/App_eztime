import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_checkin_out_model/get_checkin_out_time_month_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information_login extends StatefulWidget {
  const Information_login({super.key});

  @override
  State<Information_login> createState() => _Information_loginState();
}

class _Information_loginState extends State<Information_login> {
  List<String> _months = DateFormat.MMMM().dateSymbols.MONTHS.toList();
  List<Data> _getTimeStampData = [];
  List _itemstatusIn = [];
  int _selectedYear = DateTime.now().year;
  bool loading = false;
  int? _selectedMonth;
  bool load = false;
  var mounText;
  var token;
  @override
  void initState() {
    shareprefs();
    // TODO: implement initState
    _selectedMonth = DateTime.now().month;
    // mounText = _months[_selectedMonth! - 1];
    super.initState();
  }

  String formatMonth(String month) {
    return month.padLeft(2, '0');
  }

  Future shareprefs() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('_acessToken');

      setState(() {
        get_checkin_one_employee();
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future get_checkin_one_employee() async {
    // try {
    setState(() {
      loading = true;
    });
    var _mon = _selectedMonth.toString();
    var formate = formatMonth(_mon);
    String url = '${connect_api().domain}/GetTimeStampData';
    var response = await Dio().post(url,
        data: {"month": "$formate", "year": "$_selectedYear"},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      setState(() {
        get_checkin_out_time_month_model json =
            get_checkin_out_time_month_model.fromJson(response.data);
        _getTimeStampData = json.data!;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
    // } catch (e) {
    //   setState(() {
    //     loading = false;
    //   });
    // } finally {
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  _onRefresh() async {
    await shareprefs();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(title: Text('Check in-out.title').tr()),
            body: RefreshIndicator(
                onRefresh: () => _onRefresh(),
                child: ListView.builder(
                  itemCount: _getTimeStampData.length,
                  itemBuilder: (context, index) {
                    Color _color = Colors.grey.shade300;
                    var checkin = _getTimeStampData[index].checkinTime;
                    var checkout = _getTimeStampData[index].checkoutTime;
                    var status = _getTimeStampData[index].isWork;
                    var _late = _getTimeStampData[index].late; 
                    var _now =
                        _getTimeStampData[index].shiftDate?.split('T').first;
                    var _datetime_now = DateTime.now().toString();
                    var formate_datetime_now = _datetime_now.split(' ').first;

                    return Card(
                      elevation: 10,
                      color: _color,
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Container(
                            // color: _getTimeStampData[index]. Colors.white,
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Wrap(
                                  children: [
                                    Text('Check in-out.workingday').tr(),
                                    Text(
                                        ' ${_getTimeStampData[index].shiftDate!.split('T').first}')
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    Text('Check in-out.Timetowork').tr(),
                                    Text(
                                        ' ${_getTimeStampData[index].checkinTime!.split('T').last.split(".").first}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Check in-out.Timeoffwork').tr(),
                                    Text(
                                        ' ${_getTimeStampData[index].checkoutTime!.split('T').last.split(".").first}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('สถานะ: ').tr(),
                                    Text(
                                        ' ${status == 'true' ? 'มาทำงาน' : 'ไม่ได้มาทำงาน'}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('เวลา: ').tr(),
                                    Text(
                                        ' ${_late == 'true' ? 'สาย' : 'ปกติ'}')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          );
  }

  Widget _monthsDropDown() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(8),
      underline: Container(
        // Customize the underline
        height: 1,
        color: Theme.of(context).primaryColor,
      ),
      elevation: 5,
      style: TextStyle(fontSize: 13, color: Colors.black),
      value: _selectedMonth,
      onChanged: (newValue) {
        setState(() {
          _selectedMonth = newValue!;
          mounText = _months[newValue - 1];
          print(mounText);
          print('_selectedMonth : ${_selectedMonth}');
        });
      },
      items: List<DropdownMenuItem<int>>.generate(
        12,
        (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Text(_months[index]),
          );
        },
      ),
    );
  }

  Widget _YearDropDown() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(8),
      elevation: 5,
      underline: Container(
        // Customize the underline
        height: 1,
        color: Theme.of(context).primaryColor,
      ),
      style: TextStyle(fontSize: 13, color: Colors.black),
      value: _selectedYear,
      onChanged: (newValue) {
        setState(() {
          _selectedYear = newValue!;
          print('_selectedYear : ${_selectedYear}');
        });
      },
      items: List<DropdownMenuItem<int>>.generate(
        10,
        (index) {
          int year = DateTime.now().year - 5 + index;
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString()),
          );
        },
      ),
    );
  }
}
