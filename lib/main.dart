// ignore_for_file: prefer_const_constructors, unused_import, duplicate_import
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/Them/Them.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/Login/SetDomain_Page.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications.dart';
import 'package:eztime_app/Page/Splasscreen/Face_data_Page.dart';
import 'package:eztime_app/Test.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this line
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final messing = FirebaseMessaging.instance;


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await FaceCamera.initialize();
  NotificationService().notification();
  DartPluginRegistrant.ensureInitialized();
  initializeDateFormatting();
  MyHttpOverrides();
  // Intl.defaultLocale = "th";
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'logo_notification'); // แทนที่ด้วยชื่อไอคอนของแอปของคุณ
  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  // final service = FlutterBackgroundService();
  final prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString('_acessToken');
  var pincode = prefs.getString('pincode');
  log(_token.toString());
  runApp(EasyLocalization(
    child: MyApp(
      token: _token,
    ),
    supportedLocales: [Locale('en'), Locale('th')],
    fallbackLocale: Locale('th'),
    path: 'assets/lang',
  ));
}

class MyApp extends StatelessWidget {
  final  token;
  final pincode;
  MyApp({Key? key, this.token, this.pincode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      home: FutureBuilder<Widget>(
        future: checkAppStatus(token,pincode),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container(); // Placeholder widget while waiting for the future
          }
        },
      ),
      // home: testDecestion(),
    );
  }
}

Future<Widget> checkAppStatus(String? _token , var pincode) async {
  // var prefs = await SharedPreferences.getInstance();
  if (_token != null) {
    if (pincode != null) {
      return Pin_code();
    } else {
      return  BottomNavigationBar_Page();
    }
  } else {
   return Domain_Set_Page();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
