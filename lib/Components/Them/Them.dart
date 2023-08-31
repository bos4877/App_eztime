// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'dart:io';

ThemeData mytheme() {
  Map<int, Color> color = {
     50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  };
  return ThemeData(
    //animetion การเปลี่ยนหน้า
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder()
      },
    ),
    primarySwatch: MaterialColor(0xFF1976D2, color),
    primaryColor: Color(0xFF1976D2),
    // accentColor: Colors.transparent, //? Scroll Colors
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF1976D2),
    ),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Kanit')),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 25),
        selectedLabelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14)),
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: AppBarTheme(
      toolbarHeight: 60,
      elevation: 10,
        backgroundColor: Color(0xFF1976D2),
        centerTitle: true,
        iconTheme: IconThemeData(size: 30, color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kanit',
          fontSize: 18,
          letterSpacing: 1,
        ),),
    fontFamily: 'Kanit',
  );
}

Widget myTextScale(BuildContext context, Widget? child) {
  return MediaQuery(
      // fix ขนาดตัวอักษรของแอพ
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.2,
      ),
      child: child!);
}

Widget myScrollScreen(BuildContext context, Widget? child) {
  return ScrollConfiguration(
    // scroll listview screen การเลื่อนไลด์หน้าแอพ
    behavior: ScrollBehavior().copyWith(
        // Set the default scroll physics here
        physics: BouncingScrollPhysics()
        // Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics(),
        ),
    child: child!,
  );
}

