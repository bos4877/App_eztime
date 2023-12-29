import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Security/creaetPin/CreaetPin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security_Page extends StatefulWidget {
  const Security_Page({super.key});

  @override
  State<Security_Page> createState() => _Security_PageState();
}

class _Security_PageState extends State<Security_Page> {
  bool isSwitched = false;
  SharedPreferences? prefs;
  InputController _inputController = InputController();
  var pincode;
  Future _isSwitchedstatus() async {
    prefs = await SharedPreferences.getInstance();
   pincode = prefs!.getString('pincode');
   var Switched = prefs!.getBool('isSwitched');
   print(pincode.toString());
    if (pincode != null) {
      print(pincode);
      setState(() {
         isSwitched = Switched!;
         print(isSwitched);
      });
    }
    
  }
  @override
  void initState() {
    _isSwitchedstatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('security'),
      ),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            SizedBox(height: 20),
            MySwitch(
              title: 'pincode',
              icon: Icon(Icons.key),
              content: isSwitched ? 'on'.tr() : 'off'.tr(),
              transform_value: isSwitched,
              onChanged: (value) async {
                if (pincode == null && !isSwitched) {
                  await Pin_code_Compl().picode(context);
                  prefs!.setBool('isSwitched', true);
                  setState(() {
                    isSwitched = true;
                  });
                } else {
                  setState(() {
                    isSwitched = false;
                    prefs!.remove("pincode");
                  });
                }
                // setState(
                //   () {
                //     isSwitched = value;
                //     print('valueSecurity : ${value}');
                //   },
                // );
              },
            ),
          ],
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
