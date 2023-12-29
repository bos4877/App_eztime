import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pin_code extends StatelessWidget {
  const Pin_code({super.key});
  Future sceenlog(BuildContext context) async {
    var pin_number;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pin_number = prefs.getString('pincode');
    screenLock(
      context: context,
      correctString: pin_number,
      canCancel: false,
      title: Text('Pin Code',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20)),
      config: ScreenLockConfig(
        backgroundColor: Colors.white,
      ),
      secretsConfig: SecretsConfig(
          spacing: 15, // or spacingRatio
          padding: const EdgeInsets.all(40),
          secretConfig: SecretConfig(
            borderColor: Colors.grey,
            borderSize: 2.0,
            disabledColor: Colors.grey,
            enabledColor: Colors.blue,
            size: 15,
          )),
      useLandscape: false,
      deleteButton:
          const Icon(Icons.backspace_outlined, color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar_Page();
  }
}
