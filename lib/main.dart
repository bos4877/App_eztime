// ignore_for_file: prefer_const_constructors, unused_import, duplicate_import

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Notifications/Notifications.dart';
import 'package:eztime_app/Components/Them/Them.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/HomePage/views/Home_Page.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this line
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await initializeDateFormatting();
  // Intl.defaultLocale = "th";
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'notification'); // แทนที่ด้วยชื่อไอคอนของแอปของคุณ
  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [Locale('en'), Locale('th')],
    fallbackLocale: Locale('th'),
    path: 'assets/lang',
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: mytheme(),
      // theme: ThemeData.dark(),

      home: Builder(
        builder: (context) {
          return BottomNavigationBar_Page();
        },
      ),

      // home: test(),
    );
  }
}
