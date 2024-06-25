import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MenuPageComponents extends StatelessWidget {
  final Widget subtitle;
  final String title;
  MenuPageComponents({Key? key, required this.subtitle, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20,),
            Text(
              "homepage.appname",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ).tr(),
            Text(
              title,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ).tr(),
          ],
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: Material(
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              color: Colors.white,
              child: subtitle),
        ),
      ),
    );
  }
}
