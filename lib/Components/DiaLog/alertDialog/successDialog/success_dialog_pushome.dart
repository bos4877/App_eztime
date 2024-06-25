import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class success_dialog_pushome extends StatelessWidget {
  final detail;
  success_dialog_pushome({super.key, this.detail});

  void show(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      // barrierColor: Colors.transparent.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return success_dialog_pushome(
          detail: detail,
        );
      },
    ).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home_Page(),
        ),
        (route) => false,
      );
    });
  }

  _onPop(context) {
    Timer(Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home_Page(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizewid = MediaQuery.of(context).size.width;
    var sizehhei = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: sizehhei * 0.465,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            width: sizewid * 0.6,
            height: sizehhei * 0.15,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black26,
          body: Stack(
            children: [
              AlertDialog(
                icon: _onPop(context),
                title: Container(
                  width: sizewid * 0.6,
                  height: sizehhei * 0.2,
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Request_leave.Details'.tr(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${detail == null ? '' : detail}',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'alertdialog_lg.save_Success'.tr(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // icon:  Icon(Icons.check_circle_outline),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            bottom: sizehhei * 0.25,
            child: Card(
              elevation: 10,
              shape: CircleBorder(),
              child: Icon(
                Bootstrap.check2_circle,
                color: Colors.greenAccent.shade700,
                size: 80,
              ),
            )),
      ],
    );
  }
}
