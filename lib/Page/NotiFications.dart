// ignore_for_file: prefer_const_constructors, await_only_futures, avoid_single_cascade_in_expression_statements

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:mailer/mailer.dart'as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class notification_page extends StatefulWidget {
  const notification_page({Key? key}) : super(key: key);

  @override
  State<notification_page> createState() => _MyAppState();
}

class _MyAppState extends State<notification_page> {
  var _switch;
  String heading = 'data';
  AndroidNotificationChannelAction channelAction =
      AndroidNotificationChannelAction.createIfNotExists;

  Future<void> showNotification() async {
    print('object2');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            '0', // แทนที่ด้วย ID ของช่องแจ้งเตือนของคุณ
            'channel_name', // แทนที่ด้วยชื่อช่องแจ้งเตือนของคุณ
            icon:
                'notification', // 'channel_description', // แทนที่ด้วยคำอธิบายของช่องแจ้งเตือนของคุณ
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            // channelShowBadge: true,
            // colorized: true,
            // enableVibration: true,
            // channelAction: channelAction
            );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // รหัสการแจ้งเตือน
      'หัวข้อการแจ้งเตือน', // หัวข้อการแจ้งเตือน
      'ข้อความการแจ้งเตือน', // ข้อความการแจ้งเตือน
      platformChannelSpecifics,
    );
  }


  Future _shareprefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _switch = prefs.getBool('isSwitched');
    print('_switch : ${_switch}');
  }
  Future disableNotifications() async {
    print('object');
    final androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      // 'channel_description',
      importance: Importance.none, // ใช้ Importance.none เพื่อไม่ให้แสดงเตือน
      priority: Priority.low,
    );

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // ส่ง Notification ที่มี Importance.none เพื่อปิดการแสดงผล
    await flutterLocalNotificationsPlugin.show(
      0, // ID ของ Notification
      'Notifications Disabled',
      'Notifications have been disabled.',
      platformChannelSpecifics,
    );
  }
// Future<void> sendEmail() async {
//   final smtpServer = gmail('programmer.floor6@gmail.com', 'programmer@@6');

//   // Create an email message
//   final message = mailer.Message()
//     ..from = mailer.Address('bos4877@gmail.com', 'bos4877')
//     ..recipients.add('613170010223@rmu.ac.th') // อีเมล์ผู้รับ
//     ..subject = 'Test Email'
//     ..text = 'This is a test email message.';

//   try {
//     final sendReport = await mailer.send(message, smtpServer);
//     print('Message sent: ${sendReport.toString()}');
//   } catch (e) {
//     print('Error sending email: $e');
//   }
// }


  @override
  void initState() {
    // TODO: implement initState
    _shareprefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notification.title').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Buttons(
              press: ()async {
              //  await _shareprefs();
              //  sendEmail();
               _switch? showNotification() : disableNotifications();
              },
              title: 'ShowNotifition',
            )
          ],
        ),
      ),
    );
  }
}
