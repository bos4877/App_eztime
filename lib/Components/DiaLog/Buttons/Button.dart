// ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  String title;
  VoidCallback press;
  Buttons({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.35,
      height: 40,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            side: BorderSide(color: Color(0xFF0D47A1)),
            backgroundColor: Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 3,
            primary: Colors.black,
            foregroundColor: Color(0xFF0D47A1),
            // surfaceTintColor: Colors.amber,
          ),
          child: Text(
            title.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          onPressed: press),
    );
  }
}
