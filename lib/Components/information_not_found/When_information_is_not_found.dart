import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class information_not_found extends StatelessWidget {
  const information_not_found({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(
        //             'assets/logo_app/eztime_logo_CircleAvatar_W.png'),opacity: 0.6,scale: 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo_app/Eztime_logo_blue_png.png',
              scale: 2.5,
              opacity: AlwaysStoppedAnimation(0.5),
            ),
            Text('Data_Not_Found.title', style: TextStyle(color: Colors.grey,fontSize: 25)).tr(),
          ],
        ),
      ),
    );
  }
}
