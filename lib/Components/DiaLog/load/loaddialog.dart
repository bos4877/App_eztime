import 'dart:async';

import 'package:eztime_app/Components/DiaLog/load/rectangle_loader.dart';
import 'package:flutter/material.dart';

class LoadingController extends StatefulWidget {
  @override
  State<LoadingController> createState() => _LoadingControllerState();
}

class _LoadingControllerState extends State<LoadingController> {
  List<double> recSizes = List<double>.filled(4, 1); // กำหนดให้เป็น 4 แทน 8
  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        for (int i = 0; i < recSizes.length; i++) {
          recSizes[i] = i == counter ? 2 : 1;
        }
        counter = (counter + 1) % recSizes.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.blue, // กำหนดสีพื้นหลังของ Card
          shape: BoxShape.circle),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                  begin: 1.0, end: recSizes[index]), // แก้ไขจาก 0 เป็น 1.0
              duration: Duration(milliseconds: 300),
              builder: (_, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child:
                  rectangle_loader(), // แก้ไขจาก rectangle_loader เป็น RectangleLoader
            ),
          );
        }),
      ),
    );
  }
}
