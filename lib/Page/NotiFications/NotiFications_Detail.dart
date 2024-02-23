import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';

class NotiFications_Detail_Page extends StatefulWidget {
  final section;
  final  notificationData;
  const NotiFications_Detail_Page({super.key, this.section, this.notificationData});

  @override
  State<NotiFications_Detail_Page> createState() =>
      _NotiFications_Detail_PageState();
}

class _NotiFications_Detail_PageState extends State<NotiFications_Detail_Page> {
  @override
  void initState() {
      InternetConnectionChecker().checker();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification.title').tr()),
    
    );
  }
}
