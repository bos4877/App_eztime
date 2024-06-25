import 'package:shared_preferences/shared_preferences.dart';

var ip;
ipshare() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ip = prefs.getString('ip');
}

class connect_api {
  String? domain;
  connect_api() {
    domain = 'http://119.59.97.193:7311';
  }
}
