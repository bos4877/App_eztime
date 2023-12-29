import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotiFications_Detail_Page extends StatefulWidget {
  final section;
  const NotiFications_Detail_Page({super.key, this.section});

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
      appBar: AppBar(title: Text('Notification_Detail.title').tr()),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // กำหนดความโค้งของขอบ
              side: BorderSide(color: Colors.blue)),
          borderOnForeground: true,
          elevation: 10,
          color: Colors.white,
          child: Column(
            children: [
              Text('${widget.section}'),
              Expanded(child: Text('data')),

              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset(
                    height: 70,
                    color: Colors.blue,
                    'assets/icons_Svg/arrow-back-thick-fill.svg'),
              ),
              // SizedBox(height: 500,),
            ],
          ),
        ),
      ),
    );
  }
}
