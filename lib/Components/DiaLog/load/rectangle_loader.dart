import 'package:flutter/material.dart';

class rectangle_loader extends StatelessWidget {
  const rectangle_loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 10,
        width: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 3)
            )
          ]
        ),
      ));
  }
}
