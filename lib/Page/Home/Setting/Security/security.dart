import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Security/creaetPin/CreaetPin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security_Page extends StatefulWidget {
  const Security_Page({super.key});

  @override
  State<Security_Page> createState() => _Security_PageState();
}

class _Security_PageState extends State<Security_Page> {
  bool? isSwitched;
  SharedPreferences? prefs;
  bool loading = false;
  String pincode = '';

  @override
  void initState() {
    // loading = true;
    if (isSwitched == null) {
      isSwitched = false;
    }
    _isSwitchedstatus();
    // TODO: implement initState
    super.initState();
  }

  Future _isSwitchedstatus() async {
    setState(() {
      loading = true;
    });
    prefs = await SharedPreferences.getInstance();
    pincode = await prefs!.getString('pincode').toString();
    var Switched = await prefs!.getBool('isSwitched');
    if (isSwitched == null) {
      isSwitched = false;
    } else {
      debugPrint('pincode: ${pincode}');
      debugPrint('isSwitched: ${isSwitched}');
      if (pincode != null || pincode.isNotEmpty) {
        debugPrint('pincode: ${pincode}');
        setState(() {
          isSwitched = Switched!;
          debugPrint('isSwitched: ${isSwitched}');
          loading = false;
        });
      }
      ;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('security'),
          ),
          body: Container(
            padding: EdgeInsets.all(6),
            child: Column(
              children: [
                SizedBox(height: 20),
                MySwitch(
                  title: 'pincode',
                  icon: Icon(
                    Icons.key_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  content: isSwitched! ? 'on'.tr() : 'off'.tr(),
                  transform_value: isSwitched,
                  onChanged: (value) async {
                    setState(() {
                      debugPrint('value: ${value}');
                      if (value) {
                        isSwitched = value;
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => create_pincode(),
                        ))
                            .then((value) {
                          if (value == null) {
                            _isSwitchedstatus();
                          } else {
                            _isSwitchedstatus();
                          }
                        });
                      } else {
                        isSwitched = value;
                        prefs?.setBool('isSwitched', value);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }
}

class MySwitch extends StatelessWidget {
  final String title;
  final Icon icon;
  final String content;
  final transform_value;
  final Function(bool)? onChanged;
  const MySwitch(
      {super.key,
      required this.title,
      required this.content,
      required this.icon,
      this.transform_value,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    icon,
                    SizedBox(width: 5),
                    Text(
                      title,
                      style: TextStyle(fontSize: 13),
                    ).tr(),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      content,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              scale: 0.75,
              child: Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: transform_value,
                  onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
