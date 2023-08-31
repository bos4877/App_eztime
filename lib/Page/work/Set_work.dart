// ignore_for_file: prefer_const_constructors, prefer_collection_literals, avoid_unnecessary_containers, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, sized_box_for_whitespace, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/load/loaddialog.dart';
import 'package:eztime_app/Page/HomePage/controllers/HomePage_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart ';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Set_work extends StatefulWidget {
  Set_work({
    super.key,
    required this.image,
  });
  final image;

  @override
  State<Set_work> createState() => _Set_workState();
}

class _Set_workState extends State<Set_work> {
  // final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapController? mapController;
  bool? serviceEnabled;
  Completer<GoogleMapController> _controller = Completer();

  var latitude;
  var longitude;
  bool loading = false;
  Location location = Location();
  double radius = 50; // รัศมีในเมตรที่กำหนด

  ImageProvider decodeBase64Image(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  Future<void> checkIn() async {
    // รัศมีในหน่วยเมตร
    final workLocation = Position(
      latitude: 13.6953089, // ละติจูดสถานที่ทำงาน
      longitude: 100.6417445,
      accuracy: radius, altitude: radius, heading: radius, speed: radius,
      speedAccuracy: radius, timestamp: null, // ลองจิจูดสถานที่ทำงาน
    );

    // final currentLocation = await getLocation();

    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      workLocation.latitude,
      workLocation.longitude,
    );

    if (distance <= radius) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        title: 'ดีใจหำ',
        desc: 'มีการเข้างาน',
        btnOkOnPress: () {
          openAppSettings();

          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      print('เข้างาน');
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        title: 'พบข้อผิดพลาด',
        desc: 'ไม่ได้อยู่ในรัศมีการเข้างาน',
        btnOkOnPress: () {
          openAppSettings();

          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      print('ไม่ได้อยู่ในรัศมีการเข้างาน');
    }
  }

  Future getLocation() async {
    try {
      Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print(
          '--------------------------------------------------------------------------------------------------------');
      log('Error : ${e}');
      print(
          '--------------------------------------------------------------------------------------------------------');
    }
  }

  Future<void> getLocationAndCheckIn() async {
    setState(() {
      loading = true;
    });

    Position position = await getLocation();
    await geolocator.LocationSettings();
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

    checkIn();
  }

  @override
  void initState() {
    getLocationAndCheckIn();
    getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.now();
    DateTime _time = DateTime.now();
    var _dateformatter =
        DateFormat.yMMMMEEEEd().formatInBuddhistCalendarThai(_date);
    String _timeformat = DateFormat.Hms('th_TH').format(_time);
    return Scaffold(
      appBar: AppBar(
        title: Text('Set_work.title').tr(),
      ),
      bottomNavigationBar: 
            Container(
              color: Colors.white,
              width: 50,
              height: 40,
              child: Buttons(title: 'buttons.Save'.tr(), press: () {})),
      body: Stack(
        children: [
          latitude == null && longitude == null
              ? Center(child: Loading())
              : ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    SizedBox(height: 20),
                    // _buildAvatar(avatars[4]),
                    SizedBox(height: 10.0),
                    Text(
                      "ชื่อผู้ใช้งาน",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 30.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
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
                                    .copyWith(
                                        color: Colors.black, fontSize: 30),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "$_dateformatter",
                              style: Theme.of(context).textTheme.titleMedium,
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
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                Text(
                                  'Set_work.position',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).tr(),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 300,
                              height: 200,
                              child: Center(
                                child: latitude == null
                                    ? CircularProgressIndicator()
                                    : Expanded(
                                        child: GoogleMap(
                                          gestureRecognizers: {
                                            //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
                                            Factory<EagerGestureRecognizer>(
                                                () => EagerGestureRecognizer())
                                          },
                                          myLocationEnabled: true,
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(latitude, longitude),
                                            zoom: 15,
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
                                              strokeColor:
                                                  Colors.blue, // สีเส้นของวงกลม
                                              strokeWidth:
                                                  2, // ความกว้างของเส้นของวงกลม
                                            )
                                          ]), // เพิ่มเข้าไปใน circles
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            _controller.complete(controller);
                                          },
                                        ),
                                      ),
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
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Set_work.image',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              height: 280,
                              // Set the desired height // Set the desired height
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: decodeBase64Image('${widget.image}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          // : loading
          //     ? CircularProgressIndicator()
          //     : Center()
        ],
      ),
    );
  }
}
