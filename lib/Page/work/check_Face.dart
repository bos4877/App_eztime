import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/check_face_one/check_face_one_Model.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check_face_Page extends StatefulWidget {
  final image;
  final latitude;
  final longitude;
  final radius;
  const Check_face_Page({
    super.key,
    this.image,
    this.latitude,
    this.longitude,
    this.radius,
  });

  @override
  State<Check_face_Page> createState() => _Check_face_PageState();
}

class _Check_face_PageState extends State<Check_face_Page> {
  bool loading = false;
  var status;
  List<EmployData> _profileList = [];
  List<Results> _faceList = [];
  _getprofile() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('_acessToken');
    var service = get_profile_service();
    var response = await service.getprofile(token);
    if (response == null) {
      loading = false;
    } else {
      _profileList = [response];
      loading = false;
    }
  }

  Future _checkface(XFile file) async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('_acessToken');
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });
    String url = '${connect_api().domain}/check_face_one';
    var response = await Dio().post(url,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      setState(() {
        status = response.statusCode.toString();
        loading = false;
      });
    } else {
      log('faild');
      log('responseCheck_face_Page: ${response}');
      // Dialog_Tang().checkFacedFaildialog(context);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _checkface(widget.image);
    _getprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(title: Text('ตรวจสอบใบหน้า')),
      body: loading
          ? Center(
              child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: Colors.blue,
                ),
              ),
            )
          :  Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   status == '200' ? Icon(Icons.check_circle_outlined,
                        size: 200, color: Colors.green):Icon(Icons.close_rounded,color: Colors.red,size: 200,),
                    SizedBox(
                      height: 20,
                    ),
                    Text('รหัสพนักงาน : ${_profileList[0].employeeNo}'),
                    Text('ชื่อ : ${_profileList[0].firstName}'),
                    Text('สกุล : ${_profileList[0].lastName}'),
                    Text('บริษัท : ${_profileList[0].branchOffice}'),
                    Text('ตำแหน่ง : ${_profileList[0].department}'),
                    SizedBox(
                      height: 20,
                    ),
                    status == '200'
                        ? Buttons(
                            title: 'ลงเวลา',
                            press: () async{
                              var latitude = await widget.latitude;
                              var longitude = await widget.longitude;
                              var radius = await widget.radius;
                              var name = '${_profileList[0].firstName} ${_profileList[0].lastName}';
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Set_work(
                                  name: name,
                                  latitude: latitude,
                                  longitude:longitude ,
                                  radius: radius,
                                ),
                              ));
                            },
                          )
                        : Buttons(
                            title: 'กลับ',
                            press: () {
                              Navigator.of(context).pop(MaterialPageRoute(
                                builder: (context) => BottomNavigationBar_Page(),
                              ));
                            },
                          ),
                    loading ? Loading() : Container()
                  ]),
            ),
    );
  }
}
