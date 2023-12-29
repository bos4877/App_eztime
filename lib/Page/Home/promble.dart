// ignore_for_file: unused_import
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/View_OT_logs.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class promble_page extends StatefulWidget {
  const promble_page({super.key});

  @override
  State<promble_page> createState() => _promble_pageState();
}

class _promble_pageState extends State<promble_page> {
  bool load = false;
  List<String> dataList = [
    'ข้อมูลที่ 1',
    'ข้อมูลที่ 2',
    'ข้อมูลที่ 3',
    'ข้อมูลที่ 4',
    'ข้อมูลที่ 5',
    'ข้อมูลที่ 6',
    'ข้อมูลที่ 7',
    'ข้อมูลที่ 8',
    'ข้อมูลที่ 9',
    'ข้อมูลที่ 10',
  ];
  _onRefresh() async {
    setState(() {load = true;});
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {load = false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information.title').tr(),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child:load ? Loading() : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) => Column(
            children: [
              // SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue)),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons_Svg/newspaper.svg',
                          // color: Colors.blue,
                          width: 30,
                          height: 30,
                        ),
                        // Image.asset('assets/icons/align-left-svgrepo.svg'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          dataList[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ).tr(),
                      ],
                    ),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        expanded = false;
                      });
                    },
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                indent: 5,
                                endIndent: 5),
                            Text('ข้อมูลข่าวสาร'),
                            Text(
                                '..........................................................................................................................................')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
