// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_import, camel_case_types, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, unrelated_type_equality_checks, await_only_futures, unused_field, prefer_final_fields
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/Components/APIServices/checkface/checkface.dart';
import 'package:eztime_app/Components/APIServices/getFaceRecog/getFaceRecog.dart';
import 'package:eztime_app/Components/APIServices/get_company_local/get_local.dart';
import 'package:eztime_app/Components/APIServices/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/TextButtons/HomePage_TextButtons_More.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/get_company_local.dart';
import 'package:eztime_app/Model/Get_Model/getFaceRecog_Model/getFaceRecog_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:eztime_app/Page/Home/Setting/Drawer.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/View_OT_logs.dart';
import 'package:eztime_app/Page/request/improve_uptime.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:eztime_app/Page/work/check_Face.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Home_Page extends StatefulWidget {
  final title;
  Home_Page({super.key, this.title});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker imgpicker = ImagePicker();
  getFaceRecog_Model member = getFaceRecog_Model();
  var serviceLocal = get_company_local_Service();
  get_company_local local = get_company_local();
  List<DocList> docList = [];
  int? notificationCount = 0;
  LocationPermission? permission;
  bool _isExpanded = true;
  bool? serviceEnabled;
  bool loading = false;
  String? _timeformat;
  String? image;
  var _dateformatter;
  var selectedMenu;
  var _date;
  var _time;
  var _year;
  var _getToken;
  var _Tokenrefres;
  var _checkInternect;
  var latitude;
  var longitude;
  var radians;

  Future loadDataFromSharedPreferences() async {
     setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = prefs.getString('_acessToken');
    print(
        'Data For HomePage: $_getToken'); // ดึงข้อมูลจาก SharedPreferences ด้วยคีย์ 'responseData'
    print('Data : ${prefs.getString('_acessToken')}');
    await LoginApiService().fetchData();
    var get_ot = await get_doc_Ot_list_one_Service().model(_getToken);
    docList = get_ot;
    notificationCount = docList.length;
    getface();
      setState(() {
      loading = false;
    });
  }

  Future getface() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = prefs.getString('_acessToken');
    var localRes = await serviceLocal.model(_getToken);
    local.company = localRes;
    var cout = await getFaceRecog_Service().model(_getToken);
    member.count = cout;
    latitude = local.company!.latitude;
    longitude = local.company!.longitude;
    radians = local.company!.radians;
    setState(() {
      log('success');
      loading = false;
    });
  }

  Future _openImages() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxHeight: 1080,
        maxWidth: 1080,
      );
      log(photo.toString());
      if (photo != (null)) {
        List<int> imageBytes = await photo.readAsBytes();
        var ImagesBase64 = await convert.base64Encode(imageBytes);
        setState(() {
          image = ImagesBase64;
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Check_face_Page(
                      image: photo,
                      latitude: latitude,
                      longitude: longitude,
                      radius: radians,
                    )),
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
      print("Error while picking file. $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future _opencamera() async {
    await Permission.camera.request();
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      await Permission.location.request();
      permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied) {
        PermissionStatus serviceEnabled = await Permission.location.status;
        if (serviceEnabled.isDenied) {
          AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.warning,
              title: 'อนุญาตการเข้าถึง',
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              desc: 'อนุญาตเข้าถึงตำแหน่งของคุณ',
              btnOkText: 'เปิดตั้งค่า',
              btnOkOnPress: () {
                openAppSettings();
              },
              btnCancelOnPress: () {
                Navigator.of(context).canPop();
              })
            ..show();
        } else {
          log('latitude: ${local.company!.latitude}');
          await _openImages();
        }
      } else {
        AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            title: 'อนุญาตการเข้าถึง',
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          desc: 'กรุณาอนุญาตเข้าถึงกล้องในอุปกรณ์ของคุณ',
          btnOkOnPress: () {
            openAppSettings();
          },
          btnCancelOnPress: () {
            Navigator.of(context).canPop();
          })
        ..show();
    }
  }

  Future _formatdate() async {
    setState(() {
      loading = true;
    });
    DateTime _DateTime = await DateTime.now();
    _date = DateFormat.MMMMEEEEd('th').format(_DateTime);
    _time = DateFormat.Hms('th').format(_DateTime);
    _year = _DateTime.year + 543;
    setState(() {
      loading = false;
    });
  }

  void _openMydrawer() {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop(); // Close the drawer if it's already open
    } else {
      Scaffold.of(context).openDrawer(); // Open the drawer
    }
  }

  _onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    await loadDataFromSharedPreferences();
    await _formatdate();
    setState(() {
      log(_checkInternect.toString());
      loading = false;
    });
  }

  @override
  void initState() {
    _formatdate();
    loadDataFromSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var changeLang = context.locale.languageCode;
    return loading ? Loading() : Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('homepage.title').tr(),
          elevation: 10,
        ),
        drawerDragStartBehavior: DragStartBehavior.start,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: loading
            ? Loading()
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => _onRefresh(),
                    child: ListView(
                      padding: EdgeInsets.all(5),
                      children: [
                        SizedBox(height: 90),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icon_easytime/1x/icon_personal_available.png',
                              scale: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                                      .copyWith(
                                          color: Colors.black, fontSize: 14),
                                  colon: Text(
                                    ":",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: Colors.black, fontSize: 30),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "$_date พ.ศ. $_year",
                                    style: TextStyle(fontSize: 13),
                                  ),
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
                                Image.asset(
                                  'assets/icon_easytime/1x/icon_time.png',
                                  scale: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await getface();
                                        _opencamera();
                                      },
                                      child: Container(
                                        child: Text('homepage.Check in',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            .tr(),
                                      ),
                                    ),
                                    VerticalDivider(thickness: 2, endIndent: 5),
                                    TextButton(
                                      onPressed: () async {
                                        await getface();
                                        _opencamera();
                                      },
                                      child: Container(
                                        child: Text('homepage.Check out',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            .tr(),
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
                            initiallyExpanded: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(255, 255, 255, 1),
                            title: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons_Svg/align-left-svgrepo.svg',
                                  color: Colors.blue,
                                ),
                                // Image.asset('assets/icons/align-left-svgrepo.svg'),
                                SizedBox(
                                  width: 5,
                                ),
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
                                  TextButtons_More(
                                    notificationCount: docList.length,
                                    title: 'homepage.Request leave',
                                    page: Request_leave(),
                                    imagePath:
                                        'assets/icon_easytime/1x/icon_attendance_available.png',
                                  ),
                                  Divider(),
                                  TextButtons_More(
                                    notificationCount: docList.length,
                                      title: 'homepage.Get approval, Ot',
                                      page: Request_OT_approval(),
                                      imagePath:
                                          'assets/icon_easytime/1x/icon_attendance_available.png'),
                                  Divider(),
                                  TextButtons_More(
                                    title: 'homepage.Watch the Ot log',
                                    page: View_OT_logs(),
                                    imagePath:
                                        'assets/icon_easytime/1x/icon_report_available2.png',
                                  ),
                                  Divider(),
                                  TextButtons_More(
                                    
                                      title: 'homepage.Improve Uptime',
                                      page: improve_uptime(),
                                      imagePath:
                                          'assets/icon_easytime/1x/icon_time.png'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Text('homepage.news information',
                        //         style: TextStyles.normal)
                        //     .tr(),
                        // Buttons(
                        //   title: 'title',
                        //   press: () async {
                        //    await LoginApiService().fetchData();
                        //   },
                        // )
                      ],
                    ),
                  ),
                   
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getface();
            if (member.count == 0) {
              faceCamera().then((value) => onGoback());
            } else {
              _opencamera();
            }
          },
          child: Icon(Icons.camera_alt_outlined),
        ));
  }

  onGoback() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    await getface();
    setState(() {
      loading = false;
    });
  }
}
