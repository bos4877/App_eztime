import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_checkin_out_model/get_checkin_out_time_month_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  var mounText;
  var token;
  @override
  void initState() {
    loading = true;
    _selectedMonth = DateTime.now().month;
    shareprefs();
    // TODO: implement initState

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
// await //await get_Device_token_service().model(token);
      await get_checkin_month_employee();
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future get_checkin_month_employee() async {
    try {
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
      await Future.delayed(Duration(seconds: 1));
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
    } on DioError catch (e) {
      var data = e.response?.data.toString();
      var message = data?.split(':').last.split('}').first;
      log(message!);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _onRefresh() async {
    await shareprefs();
    _selectedMonth = DateTime.now().month;
    await get_checkin_month_employee();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: Stack(
              children: [
                MyAppBar(pagename: 'Check in-out.title'),
                card_loading_CPN(
                  loading: loading,
                  chid: Padding(
                    padding: EdgeInsets.only(top: size * 0.2),
                    child: Column(
                      children: [
                        Skeletonizer(
                          enabled: loading,
                          ignoreContainers: true,
                          enableSwitchAnimation: true,
                          child: Card(
                            elevation: 5,
                            color: Colors.grey.shade200,
                            margin: EdgeInsets.only(left: 8, right: 8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('salary_calculation.SelectMount',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold))
                                          .tr(),
                                      _monthsDropDown()
                                    ],
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'salary_calculation.SelectYear',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ).tr(),
                                        _YearDropDown(),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: card_loading_CPN(
                            loading: loading,
                            chid: ListView.builder(
                              itemCount: _getTimeStampData.length,
                              itemBuilder: (context, index) {
                                Color _color = Colors.white54;
                                var checkin =
                                    _getTimeStampData[index].checkinTime;
                                var checkout =
                                    _getTimeStampData[index].checkoutTime;
                                var status = _getTimeStampData[index].isWork;
                                var _late = _getTimeStampData[index].late;
                                var _now = _getTimeStampData[index]
                                    .shiftDate
                                    ?.split('T')
                                    .first;
                                var _datetime_now = DateTime.now().toString();
                                var formate_datetime_now =
                                    _datetime_now.split(' ').first;
                                if (_now == formate_datetime_now) {
                                  _color = Colors.green.shade200;
                                } else {
                                  _color = Colors.white;
                                }
                                return Card(
                                  // elevation: 10,
                                  color: _color,
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(8),
                                      
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Wrap(
                                              children: [
                                                Text('Check in-out.workingday')
                                                    .tr(),
                                                Text(
                                                    ' ${_getTimeStampData[index].shiftDate!.split('T').first}')
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Text('Check in-out.Timetowork')
                                                    .tr(),
                                                Text(
                                                    ' ${_getTimeStampData[index].checkinTime!.split('T').last.split(".").first}')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Check in-out.Timeoffwork')
                                                    .tr(),
                                                Text(
                                                    ' ${_getTimeStampData[index].checkoutTime!.split('T').last.split(".").first}')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Check in-out.status')
                                                    .tr(),
                                                Text(
                                                    ' ${status == 'true' ? 'มาทำงาน' : 'ไม่ได้มาทำงาน'}')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Check in-out.time').tr(),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
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
          get_checkin_month_employee();
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
    return card_loading_CPN(
      loading: loading,
      chid: DropdownButton(
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
          _selectedYear = newValue!;
          print('_selectedYear : ${_selectedYear}');
          get_checkin_month_employee();
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
      ),
    );
  }
}
