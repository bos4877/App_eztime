import 'dart:io';

import 'package:eztime_app/Components/DiaLog/internet_button/Internet_Button.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_app_settings/open_app_settings.dart';

class connect_internet_page extends StatefulWidget {
  // final VoidCallback connect;
  // final VoidCallback close;
  connect_internet_page({Key? key}) : super(key: key);

  @override
  State<connect_internet_page> createState() => _connect_internet_pageState();
}

class _connect_internet_pageState extends State<connect_internet_page> {
  bool loading = false;

  Future load() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // load();
  }

  @override
  Widget build(BuildContext context) {
    var sizehie = MediaQuery.of(context).size.height;
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('ตรวจสอบการเชื่อมต่อ'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset('assets/icons_Svg/no-wifi-svg.svg',
                      fit: BoxFit.cover,width: sizehie * 0.3,color: Colors.grey.shade500,),
                ),
                Internet_Buttons(
                  onPressBtsetting: () {
                    OpenAppSettings.openWIFISettings();
                  },
                  onPressBtclose: () {
                    exit(0);
                  },
                )
              ],
            ),
        
          );
  }
}
