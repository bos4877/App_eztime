import 'package:flutter/material.dart';

class Load_Cricle extends StatelessWidget {
  Load_Cricle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.black),
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue,
        strokeWidth: 3,
      ),
    ));
  }
}
