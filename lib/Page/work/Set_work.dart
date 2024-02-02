// ignore_for_file: prefer_const_constructors, prefer_collection_literals, avoid_unnecessary_containers, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, sized_box_for_whitespace, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison, unused_import, unnecessary_import
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
// import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/APIServices/checkface/checkface.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
// import 'package:eztime_app/Page/HomePage/controllers/HomePage_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Completer<GoogleMapController> _controller = Completer();
  var latitude;
  var longitude;
  var token;
  bool loading = false;
  Location location = Location();
  var radius; // รัศมีในเมตรที่กำหนด

  ImageProvider decodeBase64Image(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  Future shareprefs() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await _parse();
    setState(() {
      loading = false;
    });
  }

  Future _parse() async {
    latitude = await double.parse(widget.latitude);
    longitude = await double.parse(widget.longitude);
    radius = await double.parse(widget.radius);
  }

  Future checkIn(lat, lng) async {
    try {
      setState(() {
        loading = true;
      });
      String url = '${connect_api().domain}/checkIn';
      var response = await Dio().post(url,
          data: {"lat": lat, "lng": lng, "time": "", "status": ""},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          Dialog_Tang().checkinsuccessdialog(context);
        });
      } else {
        Dialog_Tang().checkinfaildialog(context);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response!.statusCode == 517) {
          Dialog_Tang().worktimefaildialog(context);
        } else {
          
        }
      } else {
        // Handle other exceptions
        print("Error: $e");
      }
    }finally{
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
        latitude = position.latitude;
        longitude = position.longitude;
        log('Latitude: $latitude');
        log('Longitude: $longitude');
        loading = false;
      });
    }

    // checkIn();
  }

  @override
  void initState() {
    shareprefs();
    InternetConnectionChecker().checker();
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
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Set_work.title').tr(),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3,
                  vertical: MediaQuery.of(context).size.height * 0.01),
              child: Buttons(
                  title: 'buttons.Save'.tr(),
                  press: () {
                    checkIn(latitude, longitude);
                  }),
            ),
            body: latitude == null && longitude == null
                ? Center(child: CircularProgressIndicator())
                : loading
                    ? Loading()
                    : SingleChildScrollView(
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // _buildAvatar(avatars[4]),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Text(
                                        "ชื่อ",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${widget.name}",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: 200,
                                    height: 100,
                                    child: DigitalClock(
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
                                  ),
                                  Text(
                                    "$_dateformatter พ.ศ. $_Year",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.blue,
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
                                      ? Loading()
                                      : Container(
                                          width: double.infinity,
                                          height: 350,
                                          child: Center(
                                            child: GoogleMap(
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
                                                target:
                                                    LatLng(latitude, longitude),
                                                zoom: 18,
                                              ),
                                              circles: Set<Circle>.of([
                                                Circle(
                                                  circleId: CircleId("1"),
                                                  center: LatLng(13.6953089,
                                                      100.6417445), // ตำแหน่งศูนย์กลางวงกลม (ละติจูด, ลองจิจูด)
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
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                _controller
                                                    .complete(controller);
                                              },
                                            ),
                                          ),
                                        ),
                                  loading ? Loading() : Container()
                                ])),
                      ));
  }
}
