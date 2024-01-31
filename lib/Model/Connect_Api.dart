import 'package:shared_preferences/shared_preferences.dart';

var ip;
ipshare() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ip = prefs.getString('ip');
}

class connect_api {
  String? domain;
  connect_api() {
    domain = 'https://53e3-27-130-254-41.ngrok-free.app';
  }
}
