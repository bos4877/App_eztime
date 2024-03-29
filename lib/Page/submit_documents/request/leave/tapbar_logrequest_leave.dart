import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/request_leave_status/request_leave_status_a.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/request_leave_status/request_leave_status_n.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/request_leave_status/request_leave_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_logrequest_leave extends StatefulWidget {
  tapbar_logrequest_leave({super.key});

  @override
  State<tapbar_logrequest_leave> createState() =>
      _tapbar_logrequest_leaveState();
}

class _tapbar_logrequest_leaveState extends State<tapbar_logrequest_leave>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool loading = false;
  List<Data> leaveList = [];
  int countLeaveW = 0;
  var token;
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
          title: Text("Leaverequestlist.title".tr()),
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
          request_leave_status_waiting(),
          request_leave_status_Approved(),
          request_leave_status_Not_approved()
        ]));
  }
}
