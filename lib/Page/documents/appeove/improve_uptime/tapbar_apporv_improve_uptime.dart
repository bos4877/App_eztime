import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/documents/appeove/improve_uptime/improve_uptime_status/approve_status_a.dart';
import 'package:eztime_app/Page/documents/appeove/improve_uptime/improve_uptime_status/approve_status_n.dart';
import 'package:eztime_app/Page/documents/appeove/improve_uptime/improve_uptime_status/approve_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_apporv_improve_uptime extends StatefulWidget {
  tapbar_apporv_improve_uptime({super.key});

  @override
  State<tapbar_apporv_improve_uptime> createState() => _tapbar_apporv_improve_uptimeState();
}

class _tapbar_apporv_improve_uptimeState extends State<tapbar_apporv_improve_uptime>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'Apporv_Improve_Uptime.Waiting_for_approval'.tr()),
    Tab(text: 'Apporv_Improve_Uptime.Approved'.tr()),
    Tab(text: 'Apporv_Improve_Uptime.cancelled'.tr()),
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
          title: Text("Apporv_Improve_Uptime.title".tr()),
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
          status_waiting_improve_uptime(),
          status_Approved_improve_uptime(),
          status_cancelled_improve_uptime()
        ]));
  }
}
