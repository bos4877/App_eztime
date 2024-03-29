// ignore_for_file: prefer_const_constructors, prefer_collection_literals, avoid_unnecessary_containers, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, sized_box_for_whitespace, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison, unused_import, unnecessary_import, null_argument_to_non_null_type
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/CustomRowCheckin/CustomRow_checkin.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_month_shift.dart';
import 'package:eztime_app/Model/worktime_status/worktime_status_model.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/controller/APIServices/checkface/checkface.dart';
import 'package:eztime_app/controller/APIServices/getattendentEmployee/get_attendent_employee_one.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart ';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Set_work extends StatefulWidget {
  final latitude;
  final longitude;
  final radius;
  final name;
  Set_work(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.radius,
      this.name});

  @override
  State<Set_work> createState() => _Set_workState();
}

class _Set_workState extends State<Set_work> {
  GoogleMapController? mapController;
  bool? serviceEnabled;
  MarkerId markerId = MarkerId("บริษัท");
  List<AttendanceData> attendanceData = [];
  // List<EmployData> _profilelist = [];
  var latitude;
  var longitude;
  double? getlat;
  double? getlong;
  var token;
  bool loading = false;
  Location location = Location();
  var radius; // รัศมีในเมตรที่กำหนด

  ImageProvider decodeBase64Image(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  Future getprofile() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await get_profile_service().getprofile(token);
      setState(() {
        if (response == null) {
          log('faile');
          setState(() {
            loading = false;
          });
        } else {
          // _profilelist = [response];

          // prefs!.setString('firstName', _profilelist[0].firstName.toString());
          // prefs!.setString('lastName', _profilelist[0].lastName.toString());
          // prefs!.setString('userid', _profilelist[0].employeeNo.toString());
          log('success');
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      loading = false;
      log(e.toString());
      //Dialog_internetError.showCustomDialog(context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future shareprefs() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await _parse();
    await _get_checkin();
    await getprofile();
    setState(() {
      loading = false;
    });
  }

  Future _get_checkin() async {
    setState(() {
      loading = true;
    });
    try {
      var get_checkin = await get_attendent_employee_one().model(token);
      log('check in : ${get_checkin}');
      if (get_checkin == null) {
        attendanceData = [];
        setState(() {
          loading = false;
        });
      } else {
        attendanceData = get_checkin;
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future _parse() async {
    latitude = await double.parse(latitude);
    longitude = await double.parse(longitude);
    radius = await double.parse(radius);
  }

  Future checkIn(lat, lng) async {
    try {
      setState(() {
        loading = true;
      });
      String url = '${connect_api().domain}/checkIn';
      var response = await Dio().post(url,
          data: {
            "lat": lat, "lng": lng,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        setState(() {
          worktime_status_model data =
              worktime_status_model.fromJson(response.data);
          if (data.message == 'นอกเวลาทำงาน') {
            Dialog_worktimefaild.showCustomDialog(context, 'นอกเวลาทำงาน');
            setState(() {
              loading = false;
            });
          } else {
            Dialog_Success.showCustomDialog(context);
            print("Error2: ${response.statusCode}");
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        log("Error1: ${response.statusCode}");
        Dialog_false.showCustomDialog(context);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 517) {
          Dialog_worktimefaild.showCustomDialog(context, 'ไม่อยู่ในกะ');
          print("Error: $e");
          setState(() {
            loading = false;
          });
        } else {
          print("Error: $e");
          setState(() {
            loading = false;
          });
        }
      } else {
        // Handle other exceptions
        print("Error: $e");
        setState(() {
          loading = false;
        });
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future getLocation() async {
    setState(() {
      loading = true;
    });
    try {
      Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      loading = false;
      return position;
    } catch (e) {
      print(
          '--------------------------------------------------------------------------------------------------------');
      log('Error : ${e}');
      print(
          '--------------------------------------------------------------------------------------------------------');
      loading = false;
    }
  }

  Future<void> getLocationAndCheckIn() async {
    setState(() {
      loading = true;
    });
    Position position = await getLocation();
    geolocator.LocationSettings();
    if (position.latitude == null || position.longitude == null) {
    } else {
      setState(() {
        getlat = position.latitude;
        getlong = position.longitude;
        log('Latitude: $getlat');
        log('Longitude: $getlong');
        loading = false;
      });
    }

    // checkIn();
  }

  var imagesbase64 = '';

  @override
  void initState() {
    latitude = widget.latitude;
    longitude = widget.longitude;
    radius = widget.radius;
    shareprefs();
    getLocationAndCheckIn();
    getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date_time = DateTime.now();
    var _dateformatter = DateFormat.MMMMEEEEd('th').format(_date_time);
    String _timeformat = DateFormat.Hms('th').format(_date_time);
    var _Year = _date_time.year + 543;

    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('Set_work.title').tr(),
            ),
            floatingActionButton: 
                Buttons(
                    title: 'buttons.Save'.tr(),
                    press: () {
                      checkIn(getlat, getlong);
                    }),
            body: latitude == null && longitude == null
                ? LoadingComponent()
                : loading
                    ? LoadingComponent()
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // _buildAvatar(avatars[4]),
                              SizedBox(height: 10.0),
                              Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Text('ข้อมูลพนักงาน'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // CustomRow_checkin(
                                      //     title: 'Set_work.EmployeeNo',
                                      //     leading:
                                      //         '${_profilelist[0].employeeNo == null || _profilelist[0].employeeNo!.isEmpty ? '' : _profilelist[0].employeeNo}'),
                                      // CustomRow_checkin(
                                      //     title: 'Set_work.name',
                                      //     leading:
                                      //         '${_profilelist[0].firstName == null || _profilelist[0].firstName!.isEmpty ? '' : _profilelist[0].firstName} ${_profilelist[0].lastName == null || _profilelist[0].lastName!.isEmpty ? '' : _profilelist[0].lastName}'),
                                      // CustomRow_checkin(
                                      //     title: 'Set_work.Company',
                                      //     leading:
                                      //         '${_profilelist[0].branchOffice == null || _profilelist[0].branchOffice!.isEmpty ?  '' :_profilelist[0].branchOffice }'),
                                      // CustomRow_checkin(
                                      //     title: 'Set_work.department',
                                      //     leading:
                                      //         '${_profilelist[0].department == null || _profilelist[0].department!.isEmpty ?  '' :_profilelist[0].department }'),
                                      // SizedBox(height: 20.0),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text('วันที่เเละเวลา')
                                        ],
                                      ),
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
                                                fontSize: 10),
                                        colon: Text(
                                          ":",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        "$_dateformatter พ.ศ. $_Year",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                          Text(
                                            'Set_work.position',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      latitude == null
                                          ? LoadingComponent()
                                          : Container(
                                              width: double.infinity,
                                              height: 350,
                                              child: Center(
                                                child:
                                                    //  mapController == null
                                                    //     ? LoadingComponent()
                                                    //     :
                                                    GoogleMap(

                                                  gestureRecognizers: {
                                                    //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
                                                    Factory<EagerGestureRecognizer>(
                                                        () =>
                                                            EagerGestureRecognizer())
                                                  },
                                                  myLocationEnabled: true,
                                                  mapType: MapType.normal,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                        
                                                    target: LatLng(
                                                        latitude, longitude),
                                                    zoom: 18,
                                                  ),
                                                  circles: Set<Circle>.of([
                                                    Circle(
                                                      circleId: CircleId("1"),
                                                      center: LatLng(latitude,
                                                          longitude), // ตำแหน่งศูนย์กลางวงกลม (ละติจูด, ลองจิจูด)
                                                      radius:
                                                          radius, // รัศมีของวงกลมในหน่วยเมตร
                                                      fillColor: Colors.blue
                                                          .withOpacity(
                                                              0.3), // สีเต็มของวงกลม
                                                      strokeColor: Colors
                                                          .blue, // สีเส้นของวงกลม
                                                      strokeWidth:
                                                          2, // ความกว้างของเส้นของวงกลม
                                                    )
                                                  ]), // เพิ่มเข้าไปใน circles
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    log('messagecontroller: ${controller}');
                                                    mapController = controller;
                                                  },
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),

                              loading ? LoadingComponent() : Container()
                            ]),
                      ),

            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
          );
  }
}
