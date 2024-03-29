import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/submit_documents/request/improve_uptime/request_improve_uptime/improve_uptime.dart';
import 'package:eztime_app/Page/submit_documents/request/ot/request_ot/Request_OT_approval.dart';
import 'package:eztime_app/Page/submit_documents/request/leave/request_leave/Request_leave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestAll_Page extends StatefulWidget {
  const RequestAll_Page({super.key});

  @override
  State<RequestAll_Page> createState() => _RequestAll_PageState();
}

class _RequestAll_PageState extends State<RequestAll_Page> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('offerDocument.title').tr(),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            card_requestAll( 
              title: 'Request leave.title',
              tap: () {
                Get.to(()=> Request_leave());
              },
            ),
            card_requestAll( 
              title: 'Get approval, Ot.title',
              tap: () {
                Get.to(()=> Request_OT_approval());
              },
            ),
            card_requestAll( 
              title: 'Improve Uptime.title',
              tap: () {
                Get.to(()=> improve_uptime());
              },
            )
          ],
        ),
      ),
    );
  }
}

class card_requestAll extends StatelessWidget {
  final String title;
  final VoidCallback tap;
  const card_requestAll(
      {super.key,
      required this.title,
      required this.tap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing:  Icon(Icons.arrow_forward_ios),
        minLeadingWidth: 4.0,
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ).tr(),
        iconColor: Theme.of(context).primaryColor,
        leading: Icon(Icons.description_outlined),
        onTap: tap,
      ),
    );
  }
}
