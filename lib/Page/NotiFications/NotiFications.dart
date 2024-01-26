// ignore_for_file: unused_import
import 'dart:developer';

import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("BackgroundMessage : ${"Title : ${message.notification?.title}, \n" "Body : ${message.notification?.body}, \n" "Data : ${message.data}"}");
}

class NotificationService {
  final messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(RemoteMessage message) async {
    
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
      icon: 'hip_logo',
      channelShowBadge: true,
      styleInformation: bigTextStyleInformation,
      // color: Theme.of(context).primaryColor,
      
      // largeIcon: DrawableResourceAndroidBitmap('logo_notification'),
      
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
    log("ForegroundMessage : ${"Title : ${message.notification?.title}, \n" "Body : ${message.notification?.body}, \n" "Data : ${message.data}"}");
  }

  Future<void> notification() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true,);
    final fCMToken = await messaging.getToken();
    log("Token : ${fCMToken}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("notifyToken", fCMToken!);

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
        
        log('${details.notificationResponseType}');
 
        // bottomController.ontapItem(2);
      },
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
  }
  stopNoti()async{
    await messaging.requestPermission(alert: false, badge: true, sound: true,announcement: true,);
  }
}
