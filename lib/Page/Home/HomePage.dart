// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_import, camel_case_types, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, unrelated_type_equality_checks, await_only_futures, unused_field, prefer_final_fields, unnecessary_null_comparison
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/CoachMark_Ui/CoachMark_ui.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/Mybuttons/My_Buttons.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/Error_dialog/logout_error_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/basicload/load_cricle.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/Security/Pin_Code.dart';
import 'package:eztime_app/Components/TextButtons/HomePage_TextButtons_More.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/check_internet/checker_internet_service.dart';
import 'package:eztime_app/Components/check_internet/connect_internet_page.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/get_company_local.dart';
import 'package:eztime_app/Model/Get_Model/face/getFaceRecog_Model/getFaceRecog_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_one_model.dart'as checkin;
import 'package:eztime_app/Page/Home/Drawer/BottomSheet_Page.dart';
import 'package:eztime_app/Page/Home/Drawer/Drawer.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Setting_Page.dart';
import 'package:eztime_app/Page/Home/Setting/Show_time_information.dart';
import 'package:eztime_app/Page/Home/Setting/facefoder/Face_data_Page.dart';
import 'package:eztime_app/Page/Home/Setting/facefoder/check_Face.dart';
import 'package:eztime_app/Page/NotiFications/NotiFications_Detail.dart';
import 'package:eztime_app/Page/NotiFications/showNotifications/showNotifications.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Appeove_document_AllPage.dart';
import 'package:eztime_app/Page/documents/Submit_documents/Request_document_approval.dart';
import 'package:eztime_app/Page/documents/appeove/improve_uptime/tapbar_apporv_improve_uptime.dart';
import 'package:eztime_app/Page/documents/appeove/leave/tapbar_apporv_leave.dart';
import 'package:eztime_app/Page/documents/appeove/ot/tapbar_apporv_ot.dart';
import 'package:eztime_app/Page/documents/request/Menu_All_Request/Request_Menu_All.dart';
import 'package:eztime_app/Page/documents/request/improve_uptime/request_improve_uptime/improve_uptime.dart';
import 'package:eztime_app/Page/documents/request/ot/request_ot/Request_OT_approval.dart';
import 'package:eztime_app/Page/login/login_Page.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:eztime_app/controller/APIServices/LoginServices/refreshToken.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/GetLeave/getleave.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_DocOne/get_DocOne.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/getFaceRecog/getFaceRecog.dart';
import 'package:eztime_app/controller/APIServices/get_addtime_list/get_addtime_list_service.dart';
import 'package:eztime_app/controller/APIServices/get_company_local/get_local.dart';
import 'package:eztime_app/controller/APIServices/getattendentEmployee/get_attendent_employee_one.dart';
import 'package:eztime_app/controller/APIServices/logOut/Logout_service.dart';
import 'package:eztime_app/controller/APIServices/loginServices/loginApiService.dart';
import 'package:eztime_app/controller/GexController/checkInternet_GetX/NetworkController.dart.dart';
import 'package:eztime_app/controller/GexController/countController/count.dart';
import 'package:eztime_app/controller/GexController/doubleTwocloseApp/doubleTwocloseApp.dart';
import 'package:eztime_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Home_Page extends StatefulWidget {
  final title;
  Home_Page({super.key, this.title});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final keyTarget = GlobalKey();
  countController countnotification = Get.put(countController());
  final ImagePicker imgpicker = ImagePicker();
  getFaceRecog_Model member = getFaceRecog_Model();
  var serviceLocal = get_company_local_Service();
  get_company_local local = get_company_local();
  SharedPreferences? prefs;
  List<EmployData> _profilelist = [];
  List<checkin.Data> _listcheckin = [];
  List<TargetFocus> targets = [];
  TutorialCoachMark? tutorialCoachMark;
  LocationPermission? permission;
  bool _isExpanded = true;
  bool? serviceEnabled;
  bool loading = false;
  int faceCount = 0;
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
//---------------------------------------------------------------------------------------------------------------------------------
  final _iconmenuList = <IconData>[
    Bootstrap.journal_text,
    Bootstrap.journal_check,
    Bootstrap.journal_plus,
    Bootstrap.person_square,
    Bootstrap.clock_history,
    Bootstrap.person_bounding_box,
    Bootstrap.gear_wide_connected
  ];
  final _itemListPage = <Widget>[
    Request_Menu_All_Page(),
    Appeove_document_All_Page(),
    RequestAll_Page(),
    Profile_Page(),
    Information_login(),
    SizedBox(),
    setting_page()
  ];
  final __itemLiseMenu = <String>[
    'homepage.Document_list',
    'Approve_documents.title',
    'homepage.send_Document',
    'Profile.title',
    'Manage_time.ClockIn/Out',
    'Set_work.title',
    'setting.title'
  ];
//---------------------------------------------------------------------------------------------------------------------------------
  void showTutorial() {
    tutorialCoachMark!..show(context: context);
  }

  Future loadDataFromSharedPreferences() async {
    await refreshToken().model();
    prefs = await SharedPreferences.getInstance();
    _getToken = await prefs!.getString('_acessToken');
    debugPrint(
        'Data For HomePage: $_getToken'); // ดึงข้อมูลจาก SharedPreferences ด้วยคีย์ 'responseData'
    debugPrint('Data : ${prefs!.getString('_acessToken')}');

    await Future.delayed(Duration(milliseconds: 800));
    await get_Device_token_service().model(_getToken).then((value) {
      if (value != '') {
      } else {
        logout_error_dialog().show(context);
        // logOut_service().model(context);
      }
    });
    getface();
    _gettime_day();
  }

  var get_checkin;
  Future _gettime_day() async {
    setState(() {
      loading = true;
    });
    var services = get_attendent_employee_one();
    await Future.delayed(Duration(milliseconds: 500));
    get_checkin = await services.model(_getToken);
    if (get_checkin == null) {
      _listcheckin = [];
      setState(() {
        loading = false;
      });
    } else {
      _listcheckin = get_checkin;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getface() async {
    setState(() {
      loading = true;
    });
    var services = getFaceRecog_Service();
    var cout = await services.model(
      context,
      _getToken,
    );
    member.count = cout;
    // log('cout ${member.count}');
    faceCount = await member.count?.toInt() ?? 0;
    await Future.delayed(Duration(milliseconds: 500));
    // faceCount = 1;
    if (faceCount != 1) {
      showTutorial();
      setState(() {
        debugPrint('cocahMark');
      });
    }
  }

  Future _openImages() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          maxHeight: 1080,
          maxWidth: 1080,
          imageQuality: 80);
      debugPrint(photo.toString());
      if (photo != (null)) {
        List<int> imageBytes = await photo.readAsBytes();
        var ImagesBase64 = await convert.base64Encode(imageBytes);
        setState(() {
          image = ImagesBase64;
          get_Device_token_service().model(_getToken).then((value) {
            debugPrint('value: ${value}');
            if (value != '') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Check_face_Page(
                  image: photo,
                ),
              ));
            } else {
              logOut_service().model(context);
            }
          });

          loading = false;
        });
      } else {
        debugPrint("No image is selected.");
        setState(() {
          loading = false;
        });
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      debugPrint(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future _opencamera() async {
    await Permission.camera.request();
    PermissionStatus status = await Permission.camera.status;
    log('statuscamera: ${status}');
    if (status.isGranted) {
      await Permission.location.request();
      permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied) {
        PermissionStatus serviceEnabled = await Permission.location.status;
        if (serviceEnabled.isDenied) {
          Dialog_allow_access dialogInstance = Dialog_allow_access(
            desc: 'homepage.locationAccess',
          );
          dialogInstance.showCustomDialog(context);
        } else {
          await _openImages();
        }
      } else {
        Dialog_allow_access dialogInstance = Dialog_allow_access(
          desc: 'homepage.locationAccess',
        );
        dialogInstance.showCustomDialog(context);
        onGoback();
      }
    } else {
      Dialog_allow_access dialogInstance = Dialog_allow_access(
        desc: 'homepage.cameraAccess',
      );
      dialogInstance.showCustomDialog(context);
    }
    onGoback();
  }

  Future _formatdate() async {
    DateTime _DateTime = await DateTime.now();
    _date = DateFormat.MMMMEEEEd('th').format(_DateTime);
    _time = DateFormat.Hms('th').format(_DateTime);
    _year = _DateTime.year + 543;
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
    await Future.delayed(Duration(milliseconds: 500));
    await loadDataFromSharedPreferences();
    await _formatdate();
    setState(() {
      debugPrint(_checkInternect.toString());
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    super.initState();
    createTutorial();
    loadDataFromSharedPreferences();
    _formatdate();
    Future.delayed(Duration(milliseconds: 500));
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // con?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var changeLang = context.locale.languageCode;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          endDrawer: MyDrawer(),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  alignment: Alignment.bottomCenter,
                  height: 170,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.inner,
                          color: Theme.of(context).primaryColor,
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        )
                      ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "homepage.appname",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ).tr(),
                            Text(
                              "homepage.title",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ).tr(),
                          ],
                        ),
                        Row(
                          children: [
                            faceCount == null || faceCount == 0
                                ? loading
                                    ? SizedBox()
                                    : Container(
                                        key: keyTarget,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(.1),
                                        ),
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: () async {
                                            await Permission.camera.request();
                                            PermissionStatus status =
                                                await Permission.camera.status;
                                            if (status.isGranted) {
                                              if (faceCount != 1) {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      testDecestion(),
                                                ))
                                                    .then((value) {
                                                  if (value == null) {
                                                    Dialog_Error_responseStatus
                                                        .showCustomDialog(
                                                      context,
                                                      'Picture not found!!',
                                                    );
                                                  } else {
                                                    onGoback();
                                                  }
                                                });
                                              } else {
                                                _opencamera();
                                              }
                                            } else {
                                              Dialog_allow_access
                                                  dialogInstance =
                                                  Dialog_allow_access(
                                                desc: 'homepage.cameraAccess',
                                              );
                                              dialogInstance
                                                  .showCustomDialog(context);
                                              onGoback();
                                            }
                                          },
                                          icon:
                                              Icon(Icons.add_a_photo_outlined),
                                          tooltip: 'เพิ่มรูปภาพ',
                                        ))
                                : SizedBox(),
                            SizedBox(
                              width: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(.1)),
                                  child: IconButton(
                                    icon: Icon(
                                      IonIcons.notifications,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Get.find<countController>().clearCount();
                                      // error_dialog(
                                      //   detail: 'alertdialog_lg.not_session',
                                      // ).show(context);
                                    },
                                  ),
                                ),
                                Obx(() {
                                  final controller =
                                      Get.find<countController>();
                                  return countnotification.count.value == 0
                                      ? SizedBox()
                                      : Positioned(
                                          right: 1,
                                          top: 0,
                                          child: Transform.scale(
                                            scale: 1.3,
                                            child: Badge(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 18, 1),
                                              label: Text(
                                                '${countnotification.count.value}',
                                                // '10',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 5,
                                                          blurStyle:
                                                              BlurStyle.inner,
                                                          offset: Offset(0, -1),
                                                          spreadRadius: 7)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        );
                                }),

                                // countnotification
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black.withOpacity(.1)),
                              child: IconButton(
                                icon: Icon(
                                  Bootstrap.menu_button_wide_fill,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState?.openEndDrawer();
                                },
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      color: Theme.of(context).primaryColor,
                      height: 120,
                    ),
                    Center(
                      child: CircleAvatar(
                        maxRadius: 103,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DigitalClock(
                                  hourMinuteDigitTextStyle: TextStyle(
                                      color: Colors.black, fontSize: 30),
                                  secondDigitTextStyle: TextStyle(
                                      color: Colors.red, fontSize: 30),
                                  colon: Text(
                                    ":",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: _listcheckin.isNotEmpty &&
                                          _listcheckin[0].checkinTime != ''
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('homepage.Check_in',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                .tr(),
                                            Text(
                                              ': ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${_listcheckin[0].checkinTime!.split('T').last.split('.').first}',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text('homepage.Check_in',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                .tr(),
                                          ],
                                        ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: _listcheckin.isNotEmpty &&
                                          _listcheckin[0].checkoutTime != ''
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text('homepage.Check_out',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                .tr(),
                                            Text(
                                              ': ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '${_listcheckin[0].checkinTime!.split('T').last.split('.').first}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text('homepage.Check_out',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                .tr(),
                                          ],
                                        ),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "$_date พ.ศ. $_year",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                GridView.builder(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 120,
                  ),
                  itemCount: _iconmenuList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Icon(
                              _iconmenuList[index],
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              __itemLiseMenu[index],
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ).tr(),
                          )
                        ],
                      ),
                      onTap: () {
                        get_Device_token_service()
                            .model(_getToken)
                            .then((value) async {
                          debugPrint('value: ${value}');
                          if (value != '') {
                            if (index == 5) {
                              getface();
                              await Permission.camera.request();
                              PermissionStatus status =
                                  await Permission.camera.status;
                              if (status.isGranted) {
                                debugPrint('faceCount: ${faceCount}');
                                if (faceCount != 1) {
                                  false_dialog(
                                    detail: 'เพิ่มรูปหน้าก่อนเข้าใช้งานเมนูนี้',
                                  ).show(context);
                                } else {
                                  _opencamera();
                                }
                              } else {
                                Dialog_allow_access dialogInstance =
                                    Dialog_allow_access(
                                  desc: 'homepage.cameraAccess',
                                );
                                dialogInstance.showCustomDialog(context);
                                onGoback();
                              }
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => _itemListPage[index],
                              ));
                            }
                          } else {
                            logOut_service().model(context);
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        loading ? LoadingComponent() : Container(),
      ],
    );
  }

  onGoback() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    await loadDataFromSharedPreferences();
    await getface();
    setState(() {
      loading = false;
    });
  }

  createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      hideSkip: true,
      onClickTarget: (targets) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (targets) => testDecestion(),
        ));
      },
    );
  }

  List<TargetFocus> _createTargets() {
    targets = [
      TargetFocus(
        identify: "Target1",
        keyTarget: keyTarget,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            builder: (context, controller) {
              return CoachMark_ui_complonance(
                text: 'homepage.detail_coach',
                onNext: () {
                  controller.skip();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => testDecestion(),
                  ));
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          ),
        ],
      )
    ];
    return targets;
  }
}
