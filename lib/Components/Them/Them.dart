// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:io';

import 'package:flutter/material.dart';

ThemeData mytheme() {
  Map<int, Color> color = {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF0392cf),
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
    useMaterial3: false,
    primarySwatch: MaterialColor(0xFF0D47A1, color),
    primaryColor: Color(0xFF1976D2),
    secondaryHeaderColor: Color(0xFFCC0000),
    // backgroundColor: Color(0xFFFFFFFF),
    scaffoldBackgroundColor: Colors.grey[200],
    textTheme: TextTheme(
      displaySmall: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 16),
      displayLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 20),
      
      // bodyMedium: TextStyle(color: Colors.black,fontSize: 30)
      // subtitle1: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 16),
      // displaySmall: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 20)
      ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF0D47A1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      outlineBorder: BorderSide(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Sarabun')),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 25),
        selectedLabelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14)),
    appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      toolbarHeight: 80,
      elevation: 15,
      shadowColor: Colors.black,
      backgroundColor: Color(0xFF1976D2),
      // centerTitle: true,
      iconTheme: IconThemeData(size: 30, color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Sarabun',
        fontSize: 20,
        letterSpacing: 1,
      ),
    ),
    fontFamily: 'Sarabun',
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
