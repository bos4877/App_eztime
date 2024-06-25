import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot_status/request_ot_status_a.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot_status/request_ot_status_n.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot_status/request_ot_status_w.dart';
import 'package:flutter/material.dart';

class tapbar_logrequest_ot extends StatefulWidget {
  tapbar_logrequest_ot({super.key});

  @override
  State<tapbar_logrequest_ot> createState() => _tapbar_logrequest_otState();
}

class _tapbar_logrequest_otState extends State<tapbar_logrequest_ot>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'OT_request_list.Waiting_for_approval'.tr()),
    Tab(text: 'OT_request_list.Approved'.tr()),
    Tab(text: 'OT_request_list.cancelled'.tr()),
  ];
  @override
  void initState() {
    
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final _selectedColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
          request_ot_status_waiting(),
          request_ot_status_Approved(),
          request_ot_status_cancelled()
        ]));
  }
}
