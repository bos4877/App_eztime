import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String pagename;
  MyAppBar({
    Key? key,
    required this.pagename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "homepage.appname",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ).tr(),
            Text(
              pagename,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ).tr(),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        height: size * 0.05,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
