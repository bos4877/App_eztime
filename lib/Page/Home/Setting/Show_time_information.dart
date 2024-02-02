import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_one_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information_login extends StatefulWidget {
  const Information_login({super.key});

  @override
  State<Information_login> createState() => _Information_loginState();
}

class _Information_loginState extends State<Information_login> {
  List<String> _months = DateFormat.MMMM().dateSymbols.MONTHS.toList();
  List<AttendanceData> attendanceData = [];
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
    mounText = _months[_selectedMonth! - 1];
    super.initState();
  }

  Future shareprefs() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('_acessToken');
      await get_checkin_one_employee();
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future get_checkin_one_employee() async {
    try {
      setState(() {
        loading = true;
      });
      String url = '${connect_api().domain}/get_attendent_employee_one_shift';
      var response = await Dio().post(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_attendent_employee_one_model json =
            get_attendent_employee_one_model.fromJson(response.data);
        attendanceData = json.attendanceData!;
      } else {}
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _onRefresh() {}

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(title: Text('ข้อมูลการเข้า-ออกงาน')),
            body: RefreshIndicator(
                onRefresh: () => _onRefresh(),
                child: ListView.builder(
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('วันที่ทำงาน: ${attendanceData[index].createAt!.split('T').first}'),
                                  Text('เวลาเข้างาน: ${attendanceData[index].timeInput}'),
                                  Text('เข้างานสาย: ${attendanceData[index].late} นาที'),
                                  Text('เวลาออกงาน:')
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
        color: Colors.blue,
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
        color: Colors.blue,
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
