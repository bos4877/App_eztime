// ignore_for_file: unused_import
import 'dart:developer';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications_Detail.dart';
import 'package:eztime_app/controller/APIServices/loginServices/loginApiService.dart';
import 'package:eztime_app/controller/GexController/countController/count.dart';
import 'package:eztime_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future handleBackgroundMessage(RemoteMessage messaged) async {
  log('messaged: ${messaged}');
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    '${messaged.notification?.body}',
    htmlFormatBigText: true,
    contentTitle: '${messaged.notification?.title}',
    htmlFormatContentTitle: true,
  );
  AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    icon: 'eztime_icon_white',
    channelShowBadge: true,
    styleInformation: bigTextStyleInformation,
  );
  DarwinNotificationDetails iosChannel = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails platformChannel =
      NotificationDetails(android: androidChannel, iOS: iosChannel);

  await flutterLocalNotificationsPlugin.show(1, messaged.notification?.title,
      messaged.notification?.body, platformChannel,
      payload: messaged.data['body']);
  countController _count = Get.put(countController());
  Get.find<countController>().incrementCount();
  log("handleBackgroundmessaged : ${"Title : ${messaged.notification?.title}, \n" "Body : ${messaged.notification?.body}, \n" "Data : ${messaged.data}"}");

  // NavigationService.removeRoute(NotiFications_Detail_Page());
}

class NotificationService {
  final messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(
    RemoteMessage message,
  ) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'eztime_icon_white',
      channelShowBadge: true,
      styleInformation: bigTextStyleInformation,
    );
    DarwinNotificationDetails iosChannel = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin.show(1, message.notification?.title,
        message.notification?.body, platformChannel,
        payload: message.data['body']);
    countController _count = Get.put(countController());
    Get.find<countController>().incrementCount();
    log("ForegroundMessage : ${"Title : ${message.notification?.title}, \n" "Body : ${message.notification?.body}, \n" "Data : ${message.data}"}");
  }

  Future<void> notification() async {
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fCMToken = await messaging.getToken();
    log("fCMToken : ${fCMToken}");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('notifyToken', fCMToken!);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('hip_logo');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // NavigationService.removeRoute(NotiFications_Detail_Page());
        Get.offAll(Home_Page());
        log('notificationResponseType: ${details.notificationResponseType}');
      },
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleBackgroundMessage);
  }
}
