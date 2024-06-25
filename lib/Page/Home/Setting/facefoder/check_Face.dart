import 'dart:developer';

import 'package:dio/dio.dart' as dioname;
import 'package:eztime_app/Components/DiaLog/alertDialog/Error_dialog/logout_error_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/face/check_face_one/check_face_one_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/controller/APIServices/getDevice_Token/getDevice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check_face_Page extends StatefulWidget {
  final image;
  const Check_face_Page({
    super.key,
    this.image,
  });

  @override
  State<Check_face_Page> createState() => _Check_face_PageState();
}

class _Check_face_PageState extends State<Check_face_Page> {
  bool loading = false;
  var status;
  var images;
  Profile_Model _profileList = Profile_Model();
  List<Results> _faceList = [];
  var latitude;
  var longitude;
  var radius;
  var token;
  var message;
  _getprofile() async {
    setState(() {
      loading = true;
    });
    var service = get_profile_service();
    var response = await service.getprofile(token);
    if (response == null) {
      log('message');
      setState(() {
        loading = false;
      });
    } else {
      _profileList.employData = response;
      setState(() {
        loading = false;
      });
    }
  }

  Future _checkface(XFile file) async {
    try {
      setState(() {
        loading = true;
      });
      dioname.FormData formData = dioname.FormData.fromMap(
        {
        'image': await dioname.MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      }
      );
      String url = '${connect_api().domain}/check_face_one';
      var response = await dioname.Dio().post(url,
          data: formData,
          options:
              dioname.Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        setState(() {
          log('success');
          status = response.statusCode.toString();
          log(status);
          loading = false;
        });
      }
    } on dioname.DioError catch (e) {
      var data = e.response!.data.toString();
      message = data.split(':').last.split('}').first;
      log(message);
      setState(() {
        loading = false;
      });
      // Dialog_Error_responseStatus.show(context, '${message}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future _oncheck() async {
    images = widget.image;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await _checkface(images);
    await _getprofile();
  }

  @override
  void initState() {
    // TODO: implement initState
    _oncheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: Stack(
          children: [
            MyAppBar(pagename: 'ตรวจสอบใบหน้า'),
            loading
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      width: 340,
                      height: 500,
                      child: Card(
                        elevation: 20,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              status == '200'
                                  ? Card(
                                      elevation: 50,
                                      shape: CircleBorder(),
                                      child: Icon(Bootstrap.check2,
                                          size: 150, color: Colors.green),
                                    )
                                  : Card(
                                      elevation: 50,
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Bootstrap.x,
                                        color: Colors.red,
                                        size: 150,
                                      ),
                                    ),
                              SizedBox(
                                height: 70,
                              ),
                              status == '200'
                                  ? Text(
                                      'ค้นหาใบหน้าสำเร็จ',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 20),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              status == '200'
                                  ? Text(
                                      'รหัสพนักงาน : ${_profileList.employData!.employeeNo}')
                                  : Container(),
                              status == '200'
                                  ? Text(
                                      'ชื่อ - สกุล : ${_profileList.employData!.firstName} ${_profileList.employData!.lastName}')
                                  : Container(),
                              status == '200'
                                  ? Text(
                                      'เวลาทำงาน : ${_profileList.employData!.employeeType}')
                                  : Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            '$message',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'ไม่พบข้อมูลใบหน้า!!',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              status == '200'
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          side: BorderSide(color: Colors.green),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          elevation: 3,
                                          foregroundColor: Colors.green,
                                        ),
                                        child: Text(
                                          'บันทึกเวลา',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          get_Device_token_service()
                                              .model(token)
                                              .then((value) {
                                            if (value != '') {
                                              Get.to(() => Set_work())?.then((value) {
                                                  if (value == null) {
                                                    _oncheck();
                                                  } else {
                                                    _oncheck();
                                                  }
                                              });
                                            } else {
                                              logout_error_dialog().show(context);
                                             
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          elevation: 3,
                                          foregroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                        child: Text(
                                          'กลับ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home_Page(),
                                                  ),
                                                  ((route) => false));
                                        },
                                      ),
                                    ),
                            ]),
                      ),
                    ),
                  ),
          ],
        )),
        loading
        ? LoadingComponent()
        : SizedBox()
      ],
    );
  }
}
