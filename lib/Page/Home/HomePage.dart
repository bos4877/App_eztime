// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_import, camel_case_types, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, unrelated_type_equality_checks, await_only_futures, unused_field, prefer_final_fields
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_model/get_doc_Ot_list_model.dart'
    as ot;
import 'package:eztime_app/Model/Get_Model/face/getFaceRecog_Model/getFaceRecog_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_addtime_list_model%20.dart'
    as addtime;
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_one_model.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_leave/get_leave_Model.dart'
    as leave;
import 'package:eztime_app/Page/Home/Drawer/Drawer.dart';
import 'package:eztime_app/Page/Login/Login_Page.dart';
import 'package:eztime_app/Page/Splasscreen/Face_data_Page.dart';
import 'package:eztime_app/Page/request/LogRequest/improve_uptime.dart';
import 'package:eztime_app/Page/request/Request_OT_approval.dart';
import 'package:eztime_app/Page/request/Request_leave.dart';
import 'package:eztime_app/Page/request/appeove/approve_improve_uptime.dart';
import 'package:eztime_app/Page/request/appeove/approve_leave.dart';
import 'package:eztime_app/Page/request/appeove/approve_ot.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:eztime_app/Page/work/check_Face.dart';
import 'package:eztime_app/controller/APIServices/LoginServices/LoginApiService.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/GetLeave/getleave.dart';
import 'package:eztime_app/controller/APIServices/checkface/checkface.dart';
import 'package:eztime_app/controller/APIServices/getFaceRecog/getFaceRecog.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_Ot_service.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_Service.dart';
import 'package:eztime_app/controller/APIServices/get_Ot/get_ot_list/get_ot_list.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:eztime_app/controller/APIServices/get_company_local/get_local.dart';
import 'package:eztime_app/controller/APIServices/getattendentEmployee/get_attendent_employee_one.dart';
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
  List<ot.DocList> docList = [];
  List<EmployData> _profilelist = [];
  List<leave.DocList> leaveList = [];
  List<addtime.DocList> _addtime = [];
  List<AttendanceData> attendanceData = [];
  int? ot_Count = 0;
  int? leave_cout = 0;
  int? _addtimeCount = 0;
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
    await getprofile();
    await get_leaveandot();
    await getface();
    setState(() {
      loading = false;
    });
  }

  Future getprofile() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('_acessToken');
      var response = await get_profile_service().getprofile(token);
      setState(() {
        log(response.toString());
        if (response == null) {
          Dialog_Tang().infodialog(context);
          log('faile');
          setState(() {
            loading = false;
          });
        } else {
          _profilelist = [response];
          prefs.setString('firstName', _profilelist[0].firstName.toString());
          prefs.setString('lastName', _profilelist[0].lastName.toString());
          prefs.setString('userid', _profilelist[0].employeeNo.toString());
          log('success');
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      loading = false;
      log(e.toString());
      Dialog_Tang().interneterrordialog(context);
    }
  }

  var get_checkin;
  Future get_leaveandot() async {
    try {
      setState(() {
        loading = true;
      });
      var get_addtime = await get_addtime_list_Service().model(_getToken);
      _addtime = get_addtime;
      var get_ot = await get_OtList_Service().model(_getToken);
      docList = get_ot;
      var get_doc_leave = await get_doc_leave_Service().model(_getToken);
      leaveList = get_doc_leave;
      int countLeaveW = leaveList
          .where((leave) => leave.docLeaveApprove![0].status == 'W')
          .length;
      int countdocListW = docList
          .where((docList) => docList.docOtApprove![0].status == 'W')
          .length;
      int countaddtimeW = docList
          .where((docList) => docList.docOtApprove![0].status == 'W')
          .length;
      ot_Count = countdocListW;
      leave_cout = countLeaveW;
      _addtimeCount = countaddtimeW;
      get_checkin = await get_attendent_employee_one().model(_getToken);
      log('check in : ${get_checkin}');
      if (get_checkin == 503) {
        attendanceData = [];
      } else {
        attendanceData = get_checkin;
      }
      print(leaveList);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
        // Dialog_Tang().interneterrordialog(context);
      });
    }
  }

  Future getface() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getToken = prefs.getString('_acessToken');
    var localRes = await serviceLocal.model(_getToken);
    local.company = localRes;
    var cout = await getFaceRecog_Service().model(_getToken);
    member.count = cout;
    latitude = local.company!.latitude;
    longitude = local.company!.longitude;
    radians = local.company!.radians;
  }

  Future _openImages() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
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
    await get_leaveandot();
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
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('homepage.title').tr(),
              elevation: 10,
              actions: [
                member.count == 0
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo_outlined),
                        tooltip: 'เพิ่มรูปภาพ',
                      )
                    : Container()
              ],
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12),
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
                                  "${_profilelist[0].firstName} ${_profilelist[0].lastName}",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ).tr(),
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
                                      hourMinuteDigitTextStyle:
                                          Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: Colors.black),
                                      secondDigitTextStyle: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: Colors.black,
                                              fontSize: 14),
                                      colon: Text(
                                        ":",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 30),
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
                            SizedBox(
                              height: 10,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            getface();
                                            if (member.count == 0) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                    builder: (context) =>
                                                        testDecestion(),
                                                  ))
                                                  .then((value) => onGoback);
                                            } else {
                                              _opencamera();
                                            }
                                          },
                                          child: Container(
                                            child: attendanceData.isNotEmpty &&
                                                    attendanceData[0]
                                                            .timeInput !=
                                                        503
                                                ? Text(
                                                    '${attendanceData[0].timeInput}')
                                                : Text('homepage.Check in',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                    .tr(),
                                          ),
                                        ),
                                        VerticalDivider(
                                            thickness: 2, endIndent: 5),
                                        TextButton(
                                          onPressed: () async {
                                            getface();
                                            if (member.count == 0) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    testDecestion(),
                                              ));
                                            } else {
                                              _opencamera()
                                                  .then((value) => onGoback());
                                            }
                                          },
                                          child: Container(
                                              child: attendanceData.isEmpty ||
                                                      attendanceData.length == 1
                                                  //     .timeInput !=
                                                  // 503
                                                  ? Text('homepage.Check out',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                      .tr()
                                                  : Text(
                                                      '${attendanceData[1].timeInput}')),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _profilelist[0].role == 'employee'
                                          ? Container()
                                          : TextButtons_More(
                                              notificationCount: leave_cout,
                                              title: 'อนุมัติลา',
                                              onPres: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          approve_leave_page(),
                                                    ))
                                                    .then(
                                                        (value) => onGoback());
                                              },
                                              imagePath:
                                                  'assets/icon_easytime/1x/icon_time.png'),
                                      _profilelist[0].role == 'employee'
                                          ? Container()
                                          : Divider(),
                                      _profilelist[0].role == 'employee'
                                          ? Container()
                                          : TextButtons_More(
                                              notificationCount: ot_Count,
                                              title: 'อนุมัติโอที',
                                              onPres: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          approve_ot_page(),
                                                    ))
                                                    .then(
                                                        (value) => onGoback());
                                              },
                                              imagePath:
                                                  'assets/icon_easytime/1x/icon_time.png'),
                                      _profilelist[0].role == 'employee'
                                          ? Container()
                                          : Divider(),
                                      _profilelist[0].role == 'employee'
                                          ? Container()
                                          : TextButtons_More(
                                              notificationCount: _addtimeCount,
                                              title:
                                                  'homepage.Watch the Ot log',
                                              onPres: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          approve_improve_uptime_page(),
                                                    ))
                                                    .then(
                                                        (value) => onGoback());
                                              },
                                              imagePath:
                                                  'assets/icon_easytime/1x/icon_report_available2.png',
                                            ),
                                      Divider(),
                                      TextButtons_More(
                                        title: 'homepage.Request leave',
                                        onPres: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    Request_leave(),
                                              ))
                                              .then((value) => onGoback());
                                        },
                                        imagePath:
                                            'assets/icon_easytime/1x/icon_attendance_available.png',
                                      ),
                                      Divider(),
                                      TextButtons_More(
                                          title: 'homepage.Get approval, Ot',
                                          onPres: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      Request_OT_approval(),
                                                ))
                                                .then((value) => onGoback());
                                          },
                                          imagePath:
                                              'assets/icon_easytime/1x/icon_attendance_available.png'),
                                      Divider(),
                                      TextButtons_More(
                                          title: 'homepage.Improve Uptime',
                                          onPres: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      improve_uptime(),
                                                ))
                                                .then((value) => onGoback());
                                          },
                                          imagePath:
                                              'assets/icon_easytime/1x/icon_time.png'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: member.count == 0
                ? Container()
                : FloatingActionButton(
                    onPressed: () async {
                      await getface();
                      if (member.count == 0) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => testDecestion(),
                        ));
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
    await get_leaveandot();
    setState(() {
      loading = false;
    });
  }
}
