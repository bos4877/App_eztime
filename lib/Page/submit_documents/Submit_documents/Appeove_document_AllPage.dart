import 'package:eztime_app/Page/submit_documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/submit_documents/appeove/improve_uptime/tapbar_apporv_improve_uptime.dart';
import 'package:eztime_app/Page/submit_documents/appeove/leave/tapbar_apporv_leave.dart';
import 'package:eztime_app/Page/submit_documents/appeove/ot/tapbar_apporv_ot.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Appeove_document_All_Page extends StatefulWidget {
  const Appeove_document_All_Page({super.key});

  @override
  State<Appeove_document_All_Page> createState() => _Appeove_document_All_PageState();
}

class _Appeove_document_All_PageState extends State<Appeove_document_All_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('อนุมัติเอกสาร')),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            card_requestAll( 
              title: 'อนุมัติลา',
              tap: () {
                Get.to(()=> tapbar_apporv_leave());
              },
            ),
            card_requestAll( 
              title: 'อนุมัติโอที',
              tap: () {
                Get.to(()=> tapbar_apporv_ot());
              },
            ),
            card_requestAll( 
              title: 'อนุมัติวันทำงาน',
              tap: () {
                Get.to(()=> tapbar_apporv_improve_uptime());
              },
            )
          ],
        ),
      ),
    );
  }
}