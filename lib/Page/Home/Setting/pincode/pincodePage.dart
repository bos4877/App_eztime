import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class pincode_page extends StatefulWidget {
  const pincode_page({super.key});

  @override
  State<pincode_page> createState() => _pincode_pageState();
}

class _pincode_pageState extends State<pincode_page> {
  bool loading = false;
var pin_number;
shareprefs()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
pin_number = prefs.getString('pincode');
}

  Future _OnStartpin() async {
    setState(() {
      loading = true;
    });
    if (pin_number == null) {
      setState(() {
        loading = false;
        return null;
      });
    } else {
      await Pin_code().sceenlog(context);
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavigationBar_Page(),));
        loading = false;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    _OnStartpin();
    shareprefs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? LoadingComponent(): Scaffold();
  }
}