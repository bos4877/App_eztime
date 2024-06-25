import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:flutter/material.dart';

class NotiFications_Detail_Page extends StatefulWidget {
  // final section;
  // final notificationData;
  const NotiFications_Detail_Page({super.key});

  @override
  State<NotiFications_Detail_Page> createState() =>
      _NotiFications_Detail_PageState();
}

class _NotiFications_Detail_PageState extends State<NotiFications_Detail_Page> {
  bool loaddialog = false;

  @override
  void initState() {
    loaddialog = true;
    Future.delayed(Duration(seconds: 2));
    loaddialog = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaddialog
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(title: Text('Notification.title').tr()),
            body: Center(
              child: Container(
                alignment: Alignment.center,
                width: 150,
                height: 150,
                color: Colors.white,
                child: Text('ยังไม่เปิดใช้งาน'),
              ),
            ),
          );
  }
}
