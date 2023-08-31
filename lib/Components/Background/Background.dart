// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
// รับค่า desiredHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Container(
          // width: double.infinity,
          // height: size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: Image.asset(
              'assets/background/Asset_1.png',
            ).image,
            fit: BoxFit.cover,
          ),
          ),

          child: child,
          ),
      );
 
  }
}
