import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/documents/appeove/ot/approve_ot_status/approve_status_a.dart';
import 'package:eztime_app/Page/documents/appeove/ot/approve_ot_status/approve_status_n.dart';
import 'package:eztime_app/Page/documents/appeove/ot/approve_ot_status/approve_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_apporv_ot extends StatefulWidget {
  tapbar_apporv_ot({super.key});

  @override
  State<tapbar_apporv_ot> createState() => _tapbar_apporv_otState();
}

class _tapbar_apporv_otState extends State<tapbar_apporv_ot>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'Approve_leave.Waiting_for_approval'.tr()),
    Tab(text: 'Approve_leave.Approved'.tr()),
    Tab(text: 'Approve_leave.cancelled'.tr()),
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
          title: Text("OT_request_list.title".tr()),
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
          status_waiting_ot(),
          status_Approved_ot(),
          status_cancelled_ot()
        ]));
  }
}
