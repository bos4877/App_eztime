// ignore_for_file: unused_field, unnecessary_null_comparison
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/Company_Model.dart';
import 'package:eztime_app/Page/login/login_Page.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final myInheritedWidget = Domain_Set_Page();
    // เก็บอ้างอิงของวิดเจ็ตที่เปิดใช้งานไว้ที่นี่
  }

  Future _gethttpsCompany(String _domainName) async {
    if (_fromkey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
//http://hipglobal/
      log('messagedomain: ${_domainName}');
      try {
        String url = '${connect_api().domain}/select_company';
        var response =
            await Dio().post(url, data: {"company_name": _domainName});
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          var json = response.data;
          company_Model member = company_Model.fromJson(json);
          log('json: ${json}');
          if (member.results![0].companyName!.isNotEmpty) {
            setState(() {
              _data = member.results!;
              var newvalue = _data.single.domain!;
              _domainList = newvalue;
              _loading = false;
            });
          } else {
            Dialog_cath().showCustomDialog(context);
          }
        } else {
          Dialog_cath().showCustomDialog(context);
          setState(() {
            _loading = false;
            print('Error: ${response.statusCode}');
          });
        }
      } catch (e) {
        setState(() {
          _data = [];

          _loading = false;
        });
        Dialog_cath().showCustomDialog(context);
        print("เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e}");
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _DropDown() {
    return DropdownButton(
      hint: Text('setdomain.select'.tr()),
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
          selectedValue = newValue!;
          // print('selectedValue: ${selectedValue}');
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
    return _loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(title: Text('setdomain.title').tr()),
            body: SingleChildScrollView(
              // controller: controller,
              child: Form(
                key: _fromkey,
                child: RefreshIndicator(
                  onRefresh: () => onRefresh(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          onFieldSubmitted: (value) =>
                              _gethttpsCompany(_domainName.text),
                          controller: _domainName,
                          decoration: InputDecoration(
                            icon: Text('setdomain.domain'.tr(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            suffixIcon: _domainName.text.isEmpty
                                ? Icon(Icons.info_outline)
                                : _loading == true
                                    ? CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                        color: Theme.of(context).primaryColor,
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
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "setdomain.input".tr(),
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'setdomain.errordomain'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'login.name',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ).tr(),
                              SizedBox(width: 10),
                              _DropDown()
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        _domainList.isEmpty
                            ? Buttons(
                                title: 'login.check_again',
                                press: () {
                                  // log('message');
                                  // Alert_Dialog(content: 'content');
                                  _gethttpsCompany(_domainName.text);
                                },
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Buttons(
                                    title: 'login.check_again',
                                    press: () {
                                      _gethttpsCompany(_domainName.text);
                                    },
                                  ),
                                  Buttons(
                                    title: 'login.next'.tr(),
                                    press: () {
                                      log('selectedValue: ${selectedValue}');
                                      if (selectedValue == null) {
                                        setState(() {
                                          Snack_Bar(
                                                  snackBarColor: Colors.red,
                                                  snackBarIcon: Icons
                                                      .warning_amber_rounded,
                                                  snackBarText:
                                                      'setdomain.select')
                                              .showSnackBar(context);
                                        });
                                      } else {
                                        // Get.offAll(() => login_Page());
                                        // Navigator.of(context)
                                        // .pushAndRemoveUntil(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             login_Page()),
                                        //     (route) => false);
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => login_Page(),
                                        ));
                                      }
                                    },
                                  ),
                                ],
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
