import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class testDecestion extends StatefulWidget {
  const testDecestion({super.key});

  @override
  State<testDecestion> createState() => _testDecestionState();
}

class _testDecestionState extends State<testDecestion> {
  bool loading = false;
  XFile? _capturedImage;
  var token;
  _SharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    _capturedImage = await faceCamera();
    uploadImage(_capturedImage!);
  }

  Future uploadImage(XFile file) async {
    FormData formData = FormData.fromMap({
      'File1': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });
    var response = await Dio().post("${connect_api().domain}/faces",
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    // log('response.data: ${response.data}');
    if (response.statusCode == 200) {
      Navigator.of(context).pop(MaterialPageRoute(
        builder: (context) => BottomNavigationBar_Page(),
      ));
      return 200;
    } else {
      log(response.statusCode.toString());
      return response.statusCode;
    }
  }

  @override
  void initState() {
    _SharedPref();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
