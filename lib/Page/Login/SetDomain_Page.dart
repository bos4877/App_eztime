// ignore_for_file: unused_field, unnecessary_null_comparison
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/Company_Model.dart';
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
  final _fromkey = GlobalKey<FormState>();
  bool _loading = false;
  bool _status = false;
  String? selectedValue;
  List<Results> _data = [];
  List<Domain> _domainList = [];
  List _conpanyName = [];
  List<String> _ipcompany = [];
  InternetConnectionStatus? _connectionStatus;
  TextEditingController _domainName = TextEditingController();
  var _checkIn;
  Future _gethttpsCompany(String _domainName) async {
    if (_fromkey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        String url = '${connect_api().domain}/select_company';
        var response =
            await Dio().post(url, data: {"company_name": _domainName});
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          var json = response.data;
          company_Model member = company_Model.fromJson(json);
          log('json: ${json}');
          setState(() {
            _data = member.results!;
            var newvalue = _data.single.domain!;
            _domainList = newvalue;
            _loading = false;
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
    } else {}
  }

  Widget _DropDown() {
    return DropdownButton(
      hint: Text('เลือกบริษัทของคุณ'),
      borderRadius: BorderRadius.circular(8),
      elevation: 5,
      style: TextStyle(fontSize: 13, color: Colors.black),
      items: _domainList.map((name) {
        return DropdownMenuItem(
            value: name.domainName, child: Text('${name.domainId}'));
      }).toList(),
      value: selectedValue,
      onChanged: (newValue) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          selectedValue = newValue;
          print('selectedValue: ${selectedValue}');
          prefs.setString('ip', selectedValue!);
        });
      },
    );
  }

  onRefresh() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    _gethttpsCompany(_domainName.text);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading():  Scaffold(
      appBar: AppBar(title: Text('Login.title').tr()),
      body: SingleChildScrollView(
        // controller: controller,
        child: Form(
          key: _fromkey,
          child: RefreshIndicator(
            onRefresh: () =>onRefresh() ,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    onFieldSubmitted: (value) => _gethttpsCompany(_domainName.text),
                    controller: _domainName,
                    decoration: InputDecoration(
                      icon: Text('domain :  ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      suffixIcon: _domainName.text.isEmpty
                          ? Icon(Icons.info_outline)
                          : _loading == true
                              ? CircularProgressIndicator(

                                  strokeWidth: 3.0,
                                  color: Colors.blue,
                                )
                              : _data.isEmpty
                                  ? Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "input domain",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 14),
          
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกโดนเมนเนม';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                  _domainList.isEmpty
                      ? Buttons(
                          title: 'ตรวจสอบ',
                          press: () {
                            _gethttpsCompany(_domainName.text);
                          },
                        )
                      : Buttons(
                          title: 'Login.next'.tr(),
                          press: () {
                            log('selectedValue: ${selectedValue}');
                            if (selectedValue == null) {
                              setState(() {
                                Snack_Bar(
                                        snackBarColor: Colors.red,
                                        snackBarIcon: Icons.warning_amber_rounded,
                                        snackBarText: 'กรุณาเลือกบริษัท')
                                    .showSnackBar(context);
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login_Page(),
                                  ));
                            }
                          },
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
