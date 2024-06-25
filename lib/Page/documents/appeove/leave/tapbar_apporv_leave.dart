import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_appreove_leave/get_appreove_leave.dart';
import 'package:eztime_app/Page/documents/appeove/leave/approve_leave_status/approve_status_a/approve_status_a.dart';
import 'package:eztime_app/Page/documents/appeove/leave/approve_leave_status/approve_status_n.dart';
import 'package:eztime_app/Page/documents/appeove/leave/approve_leave_status/approve_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_apporv_leave extends StatefulWidget {
  tapbar_apporv_leave({super.key});

  @override
  State<tapbar_apporv_leave> createState() => _tapbar_apporv_leaveState();
}

class _tapbar_apporv_leaveState extends State<tapbar_apporv_leave>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int countLeaveW = 0;
  bool loading = false;
  List<DocList> apporve_leave_List = [];
  var token;
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
      backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _selectedColor,
          title: Text("Approve_leave.title".tr()),
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
        body: TabBarView(controller: _tabController, children: [
          status_waiting(),
          status_Approved(),
          status_cancelled()
        ]));
  }
}
