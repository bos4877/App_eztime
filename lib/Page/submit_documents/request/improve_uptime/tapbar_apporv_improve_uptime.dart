import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/submit_documents/appeove/ot/approve_ot_status/approve_status_n.dart';
import 'package:eztime_app/Page/submit_documents/request/improve_uptime/improve_uptime_status/request_improve_uptime_status_status_n.dart';
import 'package:eztime_app/Page/submit_documents/request/improve_uptime/improve_uptime_status/request_improve_uptime_status_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_request_improve_uptime extends StatefulWidget {
  tapbar_request_improve_uptime({super.key});

  @override
  State<tapbar_request_improve_uptime> createState() => _tapbar_request_improve_uptimeState();
}

class _tapbar_request_improve_uptimeState extends State<tapbar_request_improve_uptime>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'Approve_leave.Waiting_for_approval'.tr()),
    Tab(text: 'Approve_leave.Approved'.tr()),
    Tab(text: 'Approve_leave.Not_approved'.tr()),
  ];
  @override
  void initState() {
    
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final _selectedColor = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _selectedColor,
          title: Text("Request_Improve_Uptime.title".tr()),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                color: Colors.grey[200]),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[200],
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
          request_improve_uptime_status_waiting(),
          request_improve_uptime_status_approved(),
          status_Not_approved_ot()
        ]));
  }
}
