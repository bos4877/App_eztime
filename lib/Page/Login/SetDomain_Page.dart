// ignore_for_file: unused_field, unnecessary_null_comparison
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Company/Company_Model.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Domain_Set_Page extends StatefulWidget {
  const Domain_Set_Page({super.key});

  @override
  State<Domain_Set_Page> createState() => _Domain_Set_PageState();
}

class _Domain_Set_PageState extends State<Domain_Set_Page> {
  bool _loading = true;
  bool _status = false;
  String? selectedValue;
  List<Results> _data = [];
  List<Domain> _domainList = [];
  InternetConnectionStatus? _connectionStatus;
  TextEditingController _domainName = TextEditingController();
  var _domain = 'POLAWAT CO.,LT';
  var ip = 'https://339c-183-88-68-84.ngrok-free.app';
  var _checkIn;
  Future _gethttpsCompany(String ip) async {
    setState(() {
      _loading = true;
    });
  SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String url = '${connect_api().domain}/select_company';
      var response = await Dio().post(url, data: {"company_name": _domain});
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = response.data;
        company_Model member = company_Model.fromJson(json);
        setState(() {
          prefs.setString('ip', ip);
          _data = member.results!;
          for (var element in _data) {
            _domainList = element.domain!;
            print(_domainList.toString());
          }
          _loading = false;
          print('_domain ${_domainList}');
          print('_names ${_data[0].companyId}');
        });
      } else {
        setState(() {
          _loading = false;
          print('Error: ${response.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
//       AwesomeDialog(
//         context: context,
//         dialogType: DialogType.warning,
//         animType: AnimType.rightSlide,
//         title: 'DiaLog.titleinternet'.tr(),
//         desc: 'DiaLog.internet'.tr(),
//         btnOkText: 'DiaLog.connect'.tr(),
//         dismissOnTouchOutside: false,
//         btnOkOnPress: () async{
//  onRefresh() ;
//         },
//       )..show();
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e}");
    }
  }

  Widget _DropDown() {
    return DropdownButton<String>(
      hint: Text('เลือกบริษัทของคุณ'),
      borderRadius: BorderRadius.circular(8),
      elevation: 5,
      style: TextStyle(fontSize: 13, color: Colors.black),
      items: _domainList.map((name) {
        return DropdownMenuItem(
            value: name.domainName,
            child:  Text('${name.domainId}')
             );
      }).toList(),
      value: selectedValue,
      onChanged: (newValue) {
        setState(() {

          selectedValue = newValue;
          print(selectedValue);
        });
      },
    );
  }

  onRefresh() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    _gethttpsCompany(ip);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // _getCompany();
    _gethttpsCompany(ip);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login.title').tr()),
      body: _loading
          ? Loading()
          : SingleChildScrollView(
              // controller: controller,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text('domain :  ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Container(
                              width: 220,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: _domainName,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: "input domain",
                                  labelStyle: TextStyle(
                                      color: Colors.blue, fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            _status == false
                                ? Container()
                                : _data == null
                                    ? Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.verified_outlined,
                                        color: Colors.green,
                                      ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _status == true
                        ? ElevatedButton(
                            onPressed: () {
                              if (_data != null) {
                                setState(() {
                                  _status = true;
                                });
                              } else {
                                setState(() {
                                  _status = false;
                                });
                              }
                            },
                            child: Text('ตรวจสอบ'))
                        : Container(),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Login.name',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ).tr(),
                      SizedBox(width: 10),
                      _DropDown()
                    ]),
                    SizedBox(
                      height: 50,
                    ),
                    Buttons(
                      title: 'Login.next'.tr(),
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login_Page(),
                            ));
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
