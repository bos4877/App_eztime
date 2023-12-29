import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  GoogleMapController? mapController;
  bool? serviceEnabled;
  Completer<GoogleMapController> _controller = Completer();
  var latitude = 13.6953089;
  var longitude = 100.6417445;
  bool loading = false;
  // Location myLocation = Location(); // Replace with the actual named constructor and parameters
  double radius = 50; // รัศมีในเมตรที่กำหนด
  Future getLocation() async {
    try {
      var position = await geolocator.Geolocator.getCurrentPosition(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data'),),
      body: GoogleMap(
        gestureRecognizers: {
          //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
          Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())
        },
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          // zoom: 15,
        ),
        circles: Set<Circle>.of([
          Circle(
            circleId: CircleId("1"),
            center: LatLng(13.6953089,
                100.6417445), // ตำแหน่งศูนย์กลางวงกลม (ละติจูด, ลองจิจูด)
            radius: radius, // รัศมีของวงกลมในหน่วยเมตร
            fillColor: Colors.blue.withOpacity(0.3), // สีเต็มของวงกลม
            strokeColor: Colors.blue, // สีเส้นของวงกลม
            strokeWidth: 2, // ความกว้างของเส้นของวงกลม
          )
        ]), // เพิ่มเข้าไปใน circles
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
