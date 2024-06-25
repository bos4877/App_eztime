import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_quota_model/get_quota_leave_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leave_quota_page extends StatefulWidget {
  const Leave_quota_page({super.key});

  @override
  State<Leave_quota_page> createState() => _Leave_quota_pageState();
}

class _Leave_quota_pageState extends State<Leave_quota_page> {
  List<Data> _quotaleave = [];
  quota_leave_model _leavename = quota_leave_model();
  bool loading = false;
  var token;
  @override
  void initState() {
    loading = true;
    // TODO: implement initState
    super.initState();
    shareprefs();
  }

  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await _getquotaLeave();
  }

  Future _getquotaLeave() async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/getquotaleaveM';
      var response = await Dio().post(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        quota_leave_model json = quota_leave_model.fromJson(response.data);
        setState(() {
          _quotaleave = json.data!;

          loading = false;
        });
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              MyAppBar(pagename: 'Manage_time.leavequota'),
              card_loading_CPN(
                loading: loading,
                chid: Padding(
                  padding: EdgeInsets.only(top: size * 0.2),
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _quotaleave.length,
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   // mainAxisExtent: 120,
                      // ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: from_quota(
                              name: '${_quotaleave[index].leaveType}',
                              trail: '${_quotaleave[index].quotaLeave}'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading
            ? LoadingComponent()
            : _quotaleave == null || _quotaleave.isEmpty
                ? information_not_found()
                : SizedBox(),
      ],
    );
  }
}

class from_quota extends StatelessWidget {
  final String name;
  final String trail;
  from_quota({super.key, required this.name, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Colors.white,
      elevation: 5,
      child: ListTile(
        style: ListTileStyle.drawer,
        title: Text('$name'),
        trailing: Text('$trail'),
      ),
    );
  }
}
