// ignore_for_file: prefer_const_constructors, unused_import, duplicate_import
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/Custom_request/leave_Custom_card/request/Custom_card_request.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/Security/creaetPin/CreaetPin.dart';
import 'package:eztime_app/Components/Them/Them.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Components/alert_image/setting_error_mode/check_debugmode/check_debugmode.dart';
import 'package:eztime_app/Components/check_internet/checker_internet_service.dart';
import 'package:eztime_app/Components/check_internet/connect_internet_page.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Get_Model/get_device_token_model/get_device_token_model.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Setting/facefoder/Face_data_Page.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications.dart';
import 'package:eztime_app/Page/login/SetDomain_Page.dart';
import 'package:eztime_app/Page/login/login_Page.dart';
import 'package:eztime_app/Test.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/loginServices/loginApiService.dart';
import 'package:eztime_app/controller/APIServices/loginServices/refreshToken.dart';
import 'package:eztime_app/controller/GexController/checkInternet_GetX/NetworkController.dart.dart';
import 'package:eztime_app/controller/GexController/lostconnect/notconnet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this line
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final messing = FirebaseMessaging.instance;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  _getDeviceToken();
  NotificationService().notification();
  DartPluginRegistrant.ensureInitialized();
  initializeDateFormatting();
  MyHttpOverrides();
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
  final prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString('_acessToken');
  var pincode = await prefs.getString('pincode');
  bool jailbroken = await FlutterJailbreakDetection.jailbroken;
  bool developerMode = await FlutterJailbreakDetection.developerMode;
  debugPrint('pincode: ${pincode}');
  debugPrint('maintoken: ${_token}');
  debugPrint('jailbroken: ${jailbroken}');
  debugPrint('developerMode: ${developerMode}');
  runApp(EasyLocalization(
    child: MyApp(
      token: _token,
      pincode: pincode,
      jailbroken: jailbroken,
      developerMode: developerMode,
    ),
    supportedLocales: [Locale('en'), Locale('th')],
    fallbackLocale: Locale('th'),
    path: 'assets/lang',
  ));
}

class MyApp extends StatelessWidget {
  final token;
  final pincode;
  final bool jailbroken;
  final bool developerMode;
  MyApp(
      {Key? key,
      this.token,
      this.pincode,
      required this.jailbroken,
      required this.developerMode});

  @override
  Widget build(BuildContext context) {
    // final liveInternet = Get.put(NetworkController(), permanent: true);
    return GetMaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: mytheme(),
        //       // home: StreamBuilder<Object>(
        //       //   initialData: 1,
        //       //     stream: _connectivityService.connectivityStreamController.stream,
        //       //     builder: (context, snapshot) {
        //       //       var dataconnect = snapshot.data;
        //       //       return dataconnect == 1
        //       //           ? LoadingComponent()
        //       //           : dataconnect == false
        //       //               ? connect_internet_page()
        //       //               : FutureBuilder<Widget>(
        //       //                 initialData: Container(),
        //       //                   future: checkAppStatus(token, pincode, context),
        //       //                   builder: (context, snapshot) {
        //       //                     log('messagesnapshot2: ${snapshot.data}');
        //       //                     if (snapshot.hasData) {
        //       //                       return snapshot.data!;
        //       //                     } else {
        //       //                       return Container(); // Placeholder widget while waiting for the future
        //       //                     }
        //       //                   },
        //       //                 );
        //       //     })
        home: FutureBuilder<Widget>(
          initialData: Container(),
          future: checkAppStatus(
              token, pincode, context, jailbroken, developerMode),
          builder: (context, snapshot) {
            debugPrint('messagesnapshot2: ${snapshot.data}');
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return Container(); // Placeholder widget while waiting for the future
            }
          },
        )
        // home: Load_Cricle()
        );
  }
}

void _getDeviceToken() async {
  // final messing = FirebaseInstanceId.getInstance().getToken(“old-sender-id”, FirebaseMessaging.INSTANCE_ID_SCOPE);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var deviceToken = await messing.getToken();
  prefs.setString('notifyToken', deviceToken!);
  debugPrint('deviceToken: ${deviceToken}');
}

Future<Widget> checkAppStatus(String? _token, var pincode, BuildContext context,
    bool jailbroken, bool developerMode) async {
  developerMode = false;
  debugPrint('checkAppStatusdeveloperMode: ${developerMode}');
  debugPrint('checkAppStatusjailbroken: ${jailbroken}');
  if (developerMode == false) {
    if (jailbroken == false) {
      if (_token != null) {
        if (pincode != null) {
          Future.delayed(Duration(milliseconds: 500)).then(
            (value) =>
                value == null ? refreshToken().model() : refreshToken().model(),
          );
          return PinCodePage();
        } else {
          Future.delayed(Duration(milliseconds: 500)).then(
            (value) =>
                value == null ? refreshToken().model() : refreshToken().model(),
          );
          return Home_Page();
        }
      } else {
        return login_Page();
      }
    } else {
      return check_depugmode();
    }
  } else {
    return check_depugmode();
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
