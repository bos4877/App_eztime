import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class not_access extends StatelessWidget {
  const not_access({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[200],
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
              Text('alert_image.not_access', style: TextStyle(color: Colors.grey,fontSize: 25)).tr(),
            ],
          ),
      ),
    );
  }
}