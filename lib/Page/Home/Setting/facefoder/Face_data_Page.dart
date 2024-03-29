import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
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
  var _capturedImage;
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
      log('_capturedImage: ${_capturedImage}');
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
        Dialog_save_Success.showCustomDialog(context);
        log('เพิ่มรูป: ${response.statusCode}');
        return 200;
      } else {
        log('เพิ่มรูป: ${response.statusCode}');
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
    return loading
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('บันทึกรูปภาพ'),
            ),
            body: Center(
                child: _capturedImage == null
                    ? Container(
                        child: Text(
                          'ไม่พบรูปภาพ',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(8),
                        width: 400,
                        height: 500,
                        color: Colors.white,
                        child: showImage())),
            //   ],
            // ) :Container(
            //   color: Colors.red,
            //   width: 400,
            //   height: 500,
            //   child:  showImage(),
            // ),
            floatingActionButton: _capturedImage == null
                ? Container()
                : Buttons(
                    title: 'buttons.Save',
                    press: () async {
                      uploadImage(_capturedImage!);
                    }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  Image? showImage() {
    // ที่อยู่ของรูปภาพ
    if (_capturedImage == null) {
      log('_capturedImage: ${_capturedImage}');
    } else {
      String image = '${_capturedImage!.path}';
      // ตรวจสอบว่ารูปภาพมีหรือไม่
      File imageFile = File(image);
      if (!imageFile.existsSync()) {
        return null;
      }
      // แสดงรูปภาพ
      return Image.file(imageFile, filterQuality: FilterQuality.high);
    }
  }
}
