// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_import, camel_case_types, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, unrelated_type_equality_checks, await_only_futures, unused_field, prefer_final_fields
import 'dart:developer';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/load/loaddialog.dart';
import 'package:eztime_app/Page/Home/Setting/Drawer.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/View_OT_logs.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'dart:convert' as convert;
import 'package:permission_handler/permission_handler.dart';

class Home_Page extends StatefulWidget {
  final title;
  Home_Page({super.key,this.title});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? loading = false;
  final ImagePicker imgpicker = ImagePicker();
  String? image;
  bool? serviceEnabled;
  LocationPermission? permission;
  bool _isExpanded = true;
  String? _timeformat;
  var _dateformatter;
  var selectedMenu;



  Future loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var ip = prefs.getString('ip');
    print(
        'Data For HomePage: ${id}'); // ดึงข้อมูลจาก SharedPreferences ด้วยคีย์ 'responseData'
  }

  Future _check() async {
    bool serviceEnabled;
    bool isOpened = await Permission.location.request().isGranted;
    var permissionStatus = await Permission.location.request();

    ///ตรวจสอบสิทธิ์การขอนุญาตโลเคชั่น
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await Geolocator.requestPermission();
    }
    if (permissionStatus.isDenied) {
      // หากไม่ได้รับอนุญาตให้เข้าถึงตำแหน่งGPS
      // ให้บังคับผู้ใช้เปิดการใช้งาน GPS
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        title: 'พบข้อผิดพลาด',
        desc: '',
        btnOkOnPress: () {
          AppSettings.openAppSettings(type: AppSettingsType.location);

          // Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future openImages(ImageSource TypeImage) async {
    try {
      setState(() {
        loading = true;
      });
      final XFile? photo = await imgpicker.pickImage(
          source: TypeImage, maxHeight: 1080, maxWidth: 1080);
      List<int> imageBytes = await photo!.readAsBytes();
      var ImagesBase64 = convert.base64Encode(imageBytes);
      if (photo != (null)) {
        setState(() {
          image = ImagesBase64;
          log(image.toString());
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Set_work(image: image),
            ),
          );
          loading = false;
        });
      } else {
        print("No image is selected.");
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      log("error while picking file. ${e}");
      setState(() {
        loading = false;
      });
    }
  }

  Future _formatdate() async {
    DateTime _date = DateTime.now();
    DateTime _time = DateTime.now();
    _dateformatter =
        DateFormat.yMMMMEEEEd().formatInBuddhistCalendarThai(_date);
    _timeformat = DateFormat.Hms().format(_time);
    print(_dateformatter);
  }

  void _openMydrawer() {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop(); // Close the drawer if it's already open
    } else {
      Scaffold.of(context).openDrawer(); // Open the drawer
    }
  }

  @override
  void initState() {
    loadDataFromSharedPreferences();
    Permission.notification.request();
    _formatdate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var changeLang = context.locale.languageCode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text( 'homepage.title').tr(),
        elevation: 10,
      ),
      drawerDragStartBehavior: DragStartBehavior.start, 
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            child: ListView(
              padding: EdgeInsets.all(5),
              children: [
                SizedBox(height: 90),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Image.asset('assets/icon_easytime/1x/icon_personal_available.png',scale: 20,color: Colors.blue,),
                        SizedBox(width: 5,),
                    Text(
                      "homepage.username",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ],
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 30.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        DigitalClock(
                          hourMinuteDigitTextStyle: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                          secondDigitTextStyle: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.black, fontSize: 14),
                          colon: Text(
                            ":",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black, fontSize: 30),
                          ),
                        ),
                        Text(
                          "$_dateformatter",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Image.asset('assets/icon_easytime/1x/icon_time.png',scale: 20,),
                        SizedBox(width: 5,),
                        Text(
                          'homepage.Check in-Check out',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ).tr(),
                      ],
                    ),
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await Permission.camera.request();
                                PermissionStatus status =
                                    await Permission.camera.status;
                                if (status.isGranted) {
                                  await Permission.location.request();
                                  permission =
                                      await Geolocator.checkPermission();
                                  if (permission != LocationPermission.denied) {
                                    PermissionStatus serviceEnabled =
                                        await Permission.location.status;
                                    if (serviceEnabled.isDenied) {
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.scale,
                                          dialogType: DialogType.warning,
                                          title: 'dialog.Allow access'.tr(),
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          desc:
                                              'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
                                          btnOkText: 'เปิดตั้งค่า',
                                          btnOkOnPress: () {
                                            openAppSettings();
                                          },
                                          btnCancelOnPress: () {
                                            Navigator.of(context).canPop();
                                          })
                                        ..show();
                                    } else {
                                      openImages(ImageSource.camera);
                                    }
                                  } else {
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.scale,
                                        dialogType: DialogType.warning,
                                        title: 'อนุญาตการเข้าถึง',
                                        titleTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        desc: 'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
                                        btnOkOnPress: () {
                                          openAppSettings();
                                        },
                                        btnCancelOnPress: () {
                                          Navigator.of(context).canPop();
                                        })
                                      ..show();
                                  }
                                } else {
                                  AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      dialogType: DialogType.warning,
                                      title: 'อนุญาตการเข้าถึง',
                                      titleTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      desc:
                                          'กรุณาอนุญาตเข้าถึงกล้องในอุปกรณ์ของคุณ',
                                      btnOkOnPress: () {
                                        openAppSettings();
                                      },
                                      btnCancelOnPress: () {
                                        Navigator.of(context).canPop();
                                      })
                                    ..show();
                                }
                              },
                              child: Container(
                                child: Text('homepage.Check in',
                                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal)).tr(),
                              ),
                            ),
                            VerticalDivider(thickness: 2, endIndent: 5),
                            TextButton(
                              onPressed: () async {
                                await Permission.camera.request();
                                PermissionStatus status =
                                    await Permission.camera.status;
                                if (status.isGranted) {
                                  await Permission.location.request();
                                  permission =
                                      await Geolocator.checkPermission();
                                  if (permission != LocationPermission.denied) {
                                    PermissionStatus serviceEnabled =
                                        await Permission.location.status;
                                    if (serviceEnabled.isDenied) {
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.scale,
                                          dialogType: DialogType.warning,
                                          title: 'อนุญาตการเข้าถึง',
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          desc:
                                              'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
                                          btnOkText: 'เปิดตั้งค่า',
                                          btnOkOnPress: () {
                                            openAppSettings();
                                          },
                                          btnCancelOnPress: () {
                                            Navigator.of(context).canPop();
                                          })
                                        ..show();
                                    } else {
                                      openImages(ImageSource.camera);
                                    }
                                  } else {
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.scale,
                                        dialogType: DialogType.warning,
                                        title: 'อนุญาตการเข้าถึง',
                                        titleTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        desc: 'กรุณาอนุญาตเข้าถึงตำแหน่งของคุณ',
                                        btnOkOnPress: () {
                                          openAppSettings();
                                        },
                                        btnCancelOnPress: () {
                                          Navigator.of(context).canPop();
                                        })
                                      ..show();
                                  }
                                } else {
                                  AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      dialogType: DialogType.warning,
                                      title: 'อนุญาตการเข้าถึง',
                                      titleTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      desc:
                                          'กรุณาอนุญาตเข้าถึงกล้องในอุปกรณ์ของคุณ',
                                      btnOkOnPress: () {
                                        openAppSettings();
                                      },
                                      btnCancelOnPress: () {
                                        Navigator.of(context).canPop();
                                      })
                                    ..show();
                                }
                              },
                              child: Container(
                                child: Text('homepage.Check out',
                                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal)).tr(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        SvgPicture.asset('assets/icons_Svg/align-left-svgrepo.svg',color: Colors.blue,),
                        // Image.asset('assets/icons/align-left-svgrepo.svg'),
                        SizedBox(width: 5,),
                        Text(
                          'homepage.More',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              ),
                        ).tr(),
                      ],
                    ),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        expanded = false;
                      });
                    },
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Request_leave(),
                            )),
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Image.asset('assets/icon_easytime/1x/icon_attendance_available.png',scale: 23,),
                                  SizedBox(width: 5,),
                                  Text('homepage.Request leave',
                                      style: TextStyles.normal).tr(),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Request_OT_approval(),
                            )),
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Image.asset('assets/icon_easytime/1x/icon_attendance_available.png',scale: 23,),
                                  SizedBox(width: 5,),
                                  Text('homepage.Get approval, Ot',
                                      style: TextStyles.normal).tr(),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => View_OT_logs(),
                            )),
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Image.asset('assets/icon_easytime/1x/icon_report_available2.png',scale: 23,),
                                  SizedBox(width: 5,),
                                  Text('homepage.Watch the Ot log',
                                      style:  TextStyles.normal).tr(),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => improve_uptime(),
                            )),
                            child: Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Image.asset('assets/icon_easytime/1x/icon_time.png',scale: 23,),
                                    SizedBox(width: 5,),
                                    Text('homepage.Improve Uptime',
                                        style:  TextStyles.normal).tr()
                                  ],
                                )),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          loading! ? Loading() : Container()
        ],
        
      ),
      
    );
  }
}

