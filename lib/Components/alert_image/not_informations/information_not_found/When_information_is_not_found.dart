import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class information_not_found extends StatelessWidget {
  const information_not_found({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/Eztime_logo_blue_png.png',
              scale: 2.5,
              opacity: AlwaysStoppedAnimation(0.5),
            ),
            Text('alert_image.data_Not_Found', style: TextStyle(color: Colors.grey,fontSize: 25,)).tr(),
          ],
        ),
      ),
    );
  }
}
