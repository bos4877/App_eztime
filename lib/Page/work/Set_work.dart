// ignore_for_file: prefer_const_constructors, prefer_collection_literals, avoid_unnecessary_containers, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, sized_box_for_whitespace, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison, unused_import, unnecessary_import, null_argument_to_non_null_type
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/CustomRowCheckin/CustomRow_checkin.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog_pushome.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/alert_image/setting_error_mode/check_fack_gps/check_fack_gps.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_location/get_location_employee.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_month_shift.dart';
import 'package:eztime_app/Model/worktime_status/worktime_status_model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:eztime_app/controller/APIServices/get_location/get_location_service.dart';
import 'package:eztime_app/controller/APIServices/getattendentEmployee/get_attendent_employee_one.dart';
import 'package:eztime_app/controller/GexController/doubleTwocloseApp/doubleTwocloseApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart ';
// import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Set_work extends StatefulWidget {
  Set_work({
    super.key,
  });

  @override
  State<Set_work> createState() => _Set_workState();
}

class _Set_workState extends State<Set_work> {
  // final _formkey = GlobalKey<FormState>();
  GoogleMapController? mapController;
  bool? serviceEnabled;
  // MarkerId markerId = MarkerId("บริษัท");
  Profile_Model _profile = Profile_Model();
  List<Data> _locationlist = [];
  double _totalDistance = 0.0;
  double? latitude;
  double? longitude;
  double? getlat;
  double? getlong;
  List<String> _itemlat = [];
  List<String> _itemlong = [];
  Set<Circle> circles = Set<Circle>();
  var token;
  bool loading = false;
  Location location = Location();
  var radius; // รัศมีในเมตรที่กำหนด

  @override
  void initState() {
    super.initState();
    loading = true;
    // _safe_device();
    shareprefs();
    getprofile();
    ischeckMock();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ImageProvider decodeBase64Image(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  Future get_location() async {
    try {
      var service = get_location_service();
      var response = await service.maodel(token).then((result) {
        if (result is int) {
          debugPrint('message: ${result}');
        } else {
          setState(() {
            _locationlist = result;
            _buildCircles(_locationlist);
            _calculateTotalDistance();
            debugPrint('_locationlist: ${_locationlist}');
          });
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
        debugPrint('get_locationcatch: ${e}');
      });
    }
  }

  Set<Circle> _buildCircles(List<Data> list_latlng) {
    List<Data> _location = list_latlng;
    for (var lat_lng in list_latlng) {
      var lad = double.parse(lat_lng.latitude.toString());
      var long = double.parse(lat_lng.longitude.toString());
      var ra = double.parse(lat_lng.radians.toString());
      circles.add(
        Circle(
          circleId: CircleId('1'),
          center: LatLng(lad, long),
          radius: ra, // Radius in meters (adjust according to your needs)
          fillColor: Colors.red.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.red,
        ),
      );
    }
    debugPrint('circles: ${circles}');
    loading = false;
    return circles;
  }

  Future getprofile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await get_profile_service().getprofile(token);
      setState(() {
        if (response == null) {
          debugPrint('faile');
          loading = false;
        } else {
          _profile.employData = response;
          debugPrint('success');
          loading = false;
        }
      });
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      //DiadebugPrint_internetError.showCustomDiadebugPrint(context);
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
    await get_location();
    debugPrint(circles.toString());
    setState(() {
      loading = false;
    });
  }

  Future checkIn(lat, lng) async {
    try {
      setState(() {
        loading = true;
      });
      debugPrint(lat.toString());
      debugPrint(lng.toString());
      String url = '${connect_api().domain}/CheckInOut';
      var response = await Dio().post(url,
          data: {
            "lat": lat,
            "lng": lng,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
       success_dialog_pushome(detail: 'บันทึกเวลาสำเร็จ',).show(context);
      } else {
        debugPrint("Error1: ${response.statusCode}");
        Dialog_false.showCustomDialog(context);
        setState(() {
          loading = false;
        });
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      false_dialog(
        detail: '${message}',
      ).show(context);
      // Dialog_Error_responseStatus.showCustomDialog(context, '');
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future ischeckMock() async {
    Position position = await getLocation();
    await Future.delayed(Duration(milliseconds: 800));
    if (position.isMocked) {
      false_dialog(
        detail: 'ตรวจพบโปรเเกรมจำลองตำแหน่งโปรดปิดใช้งาน',
      ).show(context);
      loading = false;
    } else {
      await getLocationAndCheckIn();
    }
  }

  Future getLocation() async {
    // setState(() {
    //   loading = true;
    // });

    try {
      Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      // loading = false;

      return position;
    } catch (e) {
      debugPrint(
          '--------------------------------------------------------------------------------------------------------');
      debugPrint('Error : ${e}');
      debugPrint(
          '--------------------------------------------------------------------------------------------------------');
      // loading = false;
    }
  }

  Future<void> getLocationAndCheckIn() async {
    // setState(() {
    //   loading = true;
    // });
    Position position = await getLocation();
    geolocator.LocationSettings();
    // log('position: ${position.isMocked}');
    await Future.delayed(Duration(seconds: 5));
    if (position.latitude == null || position.longitude == null) {
    } else {
      setState(() {
        getlat = position.latitude;
        getlong = position.longitude;
        debugPrint('Latitude: $getlat');
        debugPrint('Longitude: $getlong');
        loading = false;
      });
      // await
    }

    // checkIn();
  }

  Future<void> _calculateTotalDistance() async {
    Position position = await getLocation();
    double startLatitude = position.latitude;
    double startLongitude = position.longitude;
    // พิกัดของจุดแวะพักและจุดหมายปลายทาง
    double lat = 0.0;
    double long = 0.0;
    List<List<double>> destinations = [];
    for (var element in _locationlist) {
      lat = double.parse(element.latitude.toString());
      long = double.parse(element.longitude.toString());
      destinations.add(
        [lat, long],
      );
    }

// 13.6952305
// 100.6417295

    double totalDistanceInMeters = 0.0;
    double previousLatitude = startLatitude;
    double previousLongitude = startLongitude;

    for (List<double> destination in destinations) {
      double destinationLatitude = destination[0];
      double destinationLongitude = destination[1];

      totalDistanceInMeters += Geolocator.distanceBetween(
        previousLatitude,
        previousLongitude,
        destinationLatitude,
        destinationLongitude,
      );

      previousLatitude = destinationLatitude;
      previousLongitude = destinationLongitude;
      _totalDistance = totalDistanceInMeters; // แปลงเป็นกิโลเมตร
      debugPrint('_totalDistance: ${_totalDistance}');
    }
  }

  var imagesbase64 = '';

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    DateTime _date_time = DateTime.now();
    var _dateformatter = DateFormat.MMMMEEEEd('th').format(_date_time);
    String _timeformat = DateFormat.Hms('th').format(_date_time);
    var _Year = _date_time.year + 543;
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: getlat == null || getlong == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  child: Buttons(
                      title: 'buttons.Save'.tr(),
                      press: () {
                        checkIn(getlat, getlong);
                      }),
                ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  map(screenheight),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: card_data(_dateformatter, _Year.toString()),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _locationlist.length,
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.location_city,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  'สถานที่: ${_locationlist[index].locationName}'),
                            ],
                          ),
                          Text(
                              ' lat: ${_locationlist[index].latitude} long: ${_locationlist[index].longitude}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        loading
            ? LoadingComponent()
            : getlat == null || getlong == null
                ? LoadingComponent()
                : SizedBox()
      ],
    );
  }

  Widget map(var screenheight) {
    return getlat == null || getlong == null
        ? SizedBox()
        : Stack(
            children: [
              Container(
                height: screenheight * 0.5,
                child: GoogleMap(
                  gestureRecognizers: {
                    //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
                    Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())
                  },
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  mapType: MapType.terrain,
                  trafficEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(getlat!, getlong!),
                    zoom: 15,
                  ),

                  circles: circles,
                  // เพิ่มเข้าไปใน circles
                  onMapCreated: (GoogleMapController controller) async {
                    await get_location();
                    debugPrint('messagecontroller: ${controller}');
                    mapController = controller;
                  },
                ),
              ),
              Container(
                height: 90,
                width: double.infinity,
                // color: Colors.white.withOpacity(0.4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              zoomControl(),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Set_work.title',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).tr(),
                  ],
                ),
              ),
              Positioned(
                  child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Bootstrap.arrow_left_short,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              )),
            ],
          );
  }

  Widget card_data(String date, String year) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            Text('ข้อมูลพนักงาน')
          ],
        ),
        CustomRow_checkin(
            title: 'Set_work.EmployeeNo',
            leading:
                '${_profile.employData?.employeeNo == null || _profile.employData!.employeeNo!.isEmpty ? '' : _profile.employData!.employeeNo}'),
        CustomRow_checkin(
            title: 'Set_work.name',
            leading:
                '${_profile.employData?.firstName == null || _profile.employData!.firstName!.isEmpty ? '' : _profile.employData!.firstName} ${_profile.employData?.lastName == null || _profile.employData!.lastName!.isEmpty ? '' : _profile.employData!.lastName}'),
        SizedBox(height: 10.0),
        Row(
          children: [
            Icon(
              Icons.punch_clock,
              color: Theme.of(context).primaryColor,
            ),
            Text('วันที่เเละเวลา'),
            DigitalClock(
              is24HourTimeFormat: true,
              hourMinuteDigitTextStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.black),
              secondDigitTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              digitAnimationStyle: Curves.easeInOut,
              showSecondsDigit: true,
              colon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  ':',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "$date พ.ศ. $year",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
            ),
            Text('ตำแหนงของคุณ')
          ],
        ),
        Text(' lat: ${getlat} long:$getlong'),

      ],
    );
  }

  Widget zoomControl() {
    return Positioned(
      right: 10,
      top: 80,
      child: Opacity(
        opacity: 0.7,
        child: Column(
          children: [
            Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                color: Colors.white,
                child: InkWell(
                  onTap: () => setState(() {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLng(LatLng(getlat!, getlong!)),
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.my_location_rounded,
                        size: 30, color: Colors.grey[800]),
                  ),
                )),
            SizedBox(
              height: 5,
            ),
            Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                color: Colors.white,
                child: InkWell(
                  onTap: () => setState(() {
                    mapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.add, size: 30, color: Colors.grey[800]),
                  ),
                )),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                color: Colors.white,
                child: InkWell(
                  onTap: () => setState(() {
                    mapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child:
                        Icon(Icons.remove, size: 30, color: Colors.grey[800]),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Dialog_setwork_Success extends StatelessWidget {
  Dialog_setwork_Success();

  _onPop(context) {
    Timer(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home_Page(),
          ),
          ((route) => false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            save_Success,
            style: TextStyle(fontSize: 16),
          ).tr(),
        ],
      ),
      icon: _onPop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Dialog_setwork_Success();
      },
    );
  }
}
