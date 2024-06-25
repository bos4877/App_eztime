import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class check_depugmode extends StatelessWidget {
  const check_depugmode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('error_debug.title').tr(),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Bootstrap.exclamation_triangle,
              color: Colors.amber,
              size: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Text('error_debug.1',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.2',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.3',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.4',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.5',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.6',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.7',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.8',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.9',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.10',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.11',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.12',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.13',style: TextStyles.textStyledebug,).tr(),
            SizedBox(
              height: 5,
            ),
            Text('error_debug.14',style: TextStyles.textStyledebug,).tr()
          ],
        ),
      ),
      floatingActionButton:
      
          ElevatedButton(onPressed: () {
            Get.until((route) => false);
          }, child: Text('error_debug.but').tr()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
