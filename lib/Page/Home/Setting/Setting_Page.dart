// ignore_for_file: unused_element, unused_local_variable, unused_import, body_might_complete_normally_nullable
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/setting_Components/card_component.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Setting/Security/security.dart';
import 'package:eztime_app/Page/Home/Setting/pincode/pincodePage.dart';
import 'package:eztime_app/Page/Home/Setting/reset_password.dart';
import 'package:eztime_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting_page extends StatefulWidget {
  const setting_page({super.key});

  @override
  State<setting_page> createState() => _setting_pageState();
}

class _setting_pageState extends State<setting_page> {
  bool isSwitched = false;
  bool agree = false;
  bool load = false;
  String? _selectedName; // ค่าที่ถูกเลือกจาก Dropdown
  var lang;
  List item = ['TH', 'ENG'];
  Future _isSwitchedstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = prefs.getBool('isSwitched') ?? false;
    print(isSwitched);
    if (isSwitched == false) {
      setState(() {
        isSwitched = false;
      });
    } else {
      setState(() {
        isSwitched = true;
      });
    }
  }

  Future<void> _saveSelectedLanguage(String selectedLanguage) async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
    if (selectedLanguage != '') {
      _getSelectedLanguage();

      await Future.delayed(Duration(seconds: 5)).then((value) {
        Restart.restartApp();
        setState(() {
          load = false;
        });
      });
    }
  }

  Future<String?> _getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedName = prefs.getString('selectedLanguage') ?? 'TH';
    setState(() {
      print(_selectedName);
      if (_selectedName == 'ENG') {
        context.setLocale(Locale('en'));
        load = false;
      } else {
        context.setLocale(Locale('th'));
        load = false;
      }
    });
  }

  @override
  void initState() {
    _isSwitchedstatus();
    _getSelectedLanguage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getSelectedLanguage();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'setting.title',
        ).tr(),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => BottomNavigationBar_Page(),
                )),
            icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: load
          ? LoadingComponent()
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  card_cpn(
                    press: () {
                      Get.to(() => reset_password());
                    },
                    title: 'setting.ChangePassword',
                    icon: Icons.key_outlined,
                  ),
                  card_cpn(
                    press: () {
                      Get.to(() => Security_Page());
                    },
                    title: 'setting.SecuritySettings',
                    icon: Icons.security_rounded,
                  ),
                  Container(
                    width: double.infinity,
                    child: Card(
                      child: IconButton(
                        onPressed: () {},
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.language,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'setting.changeLang',
                                  style: TextStyles.setting_Style,
                                ).tr(),
                              ],
                            ),
                            _lang()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icon_easytime/1x/icon_alert_available.png',
                                    scale: 30,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'setting.Notification',
                                    style: TextStyle(fontSize: 13),
                                  ).tr(),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    isSwitched
                                        ? 'setting.on'.tr()
                                        : 'setting.off'.tr(),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.75,
                            child: Switch(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: isSwitched,
                              onChanged: (value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                _isSwitchedstatus();
                                setState(
                                  () {
                                    isSwitched = value;
                                    print('value : ${value}');
                                    prefs.setBool('isSwitched', isSwitched);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _lang() {
    return Container(
      width: 100,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text(
            '${_selectedName}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: item
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: _selectedName,
          onChanged: (value) {
            setState(() {
              // print(_selectedName);
              print(value.toString());
              if (value.toString() == _selectedName) {
              } else {
                _selectedName = value.toString();
                _saveSelectedLanguage(value.toString());
              }
            });
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 140,
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }
}

class MySwitch extends StatelessWidget {
  final String title;
  final Icon icon;
  final String content;
  final transform_value;
  final Function(bool)? onChanged;
  const MySwitch(
      {super.key,
      required this.title,
      required this.content,
      required this.icon,
      this.transform_value,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    icon,
                    SizedBox(width: 5),
                    Text(
                      title,
                      style: TextStyle(fontSize: 13),
                    ).tr(),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      content,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              scale: 0.75,
              child: Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: transform_value,
                  onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
