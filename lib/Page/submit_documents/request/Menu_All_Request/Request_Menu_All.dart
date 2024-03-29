import 'package:eztime_app/Page/submit_documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/submit_documents/request/improve_uptime/tapbar_apporv_improve_uptime.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/tapbar_logrequest_leave.dart';
import 'package:eztime_app/Page/submit_documents/request/ot/tapbar_logrequest_ot.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Request_Menu_All_Page extends StatefulWidget {
  const Request_Menu_All_Page({super.key});

  @override
  State<Request_Menu_All_Page> createState() => _Request_Menu_All_PageState();
}

class _Request_Menu_All_PageState extends State<Request_Menu_All_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการเอกสาร')),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            card_requestAll( 
              title: 'เอกสารขอลางาน',
              tap: () {
                Get.to(()=> tapbar_logrequest_leave());
              },
            ),
            card_requestAll( 
              title: 'เอกสารขอโอที',
              tap: () {
                Get.to(()=> tapbar_logrequest_ot());
              },
            ),
            card_requestAll( 
              title: 'เอกสารขอปรับปรุงเวลาทำงาน',
              tap: () {
                Get.to(()=> tapbar_request_improve_uptime());
              },
            )
          ],
        ),
      ),
    );
  }
}