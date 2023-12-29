import 'dart:async';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternetConnectionChecker {
  StreamSubscription<InternetConnectionStatus>? _subscription;
  InternetConnectionStatus? connectionStatus ;
  Future<InternetConnectionStatus> checker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final completer = Completer<InternetConnectionStatus>();

    _subscription = InternetConnectionCheckerPlus().onStatusChange.listen((status) {
      connectionStatus = status;
      
      if (connectionStatus == InternetConnectionStatus.disconnected) {
        Snack_Bar(snackBarColor: Colors.amber, snackBarIcon: Icons.info_outline_rounded, snackBarText: 'homepage.catch');
       return completer.complete(InternetConnectionStatus.disconnected);
      } else {
        Snack_Bar(snackBarColor: Colors.green, snackBarIcon: Icons.info_outline_rounded, snackBarText: 'homepage.catch');
      return  completer.complete(InternetConnectionStatus.connected);
      }
      
    });
    return completer.future;
  }
}
