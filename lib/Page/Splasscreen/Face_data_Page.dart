import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
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
  var firstName;
  _SharedPref() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('_acessToken');
      firstName = prefs.getString('firstName');
      log(firstName.toString());
      _capturedImage = await faceCamera();
      uploadImage(_capturedImage!);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future uploadImage(XFile file) async {
    setState(() {
      loading = true;
    });
    try {
      FormData formData = FormData.fromMap({
        'File1': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
        'label': firstName
      });
      var response = await Dio().post("${connect_api().domain}/faces",
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      // log('response.data: ${response.data}');
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BottomNavigationBar_Page(),
        ));
        log(response.statusCode.toString());
        return 200;
      } else {
        log(response.statusCode.toString());
        return response.statusCode;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
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
    return loading ? Loading() : Scaffold();
  }
}
