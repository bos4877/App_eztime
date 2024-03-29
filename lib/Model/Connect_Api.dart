import 'package:shared_preferences/shared_preferences.dart';

var ip;
ipshare() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ip = prefs.getString('ip');
}

class connect_api {
  String? domain;
  connect_api() {
    domain = 'http://192.168.9.231:7310';
  }
}
