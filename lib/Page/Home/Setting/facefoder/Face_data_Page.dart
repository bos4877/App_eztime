import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/alert_image/not_informations/information_not_found/When_information_is_not_found.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/face_model/check_face_message_model.dart';
import 'package:eztime_app/Page/work/Set_work.dart';
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
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
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
      if (response.statusCode == 200) {
        check_face_message_model jsonmessage =
            check_face_message_model.fromJson(response.data);
        if (jsonmessage.message == 'Face not found') {
          Dialog_Error_responseStatus.showCustomDialog(context, '${jsonmessage.message}');
        } else {
          Dialog_setwork_Success.showCustomDialog(context);
          log('เพิ่มรูป: ${response.statusCode}');
        }
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
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
                    ? information_not_found()
                    : Container(
                        padding: EdgeInsets.all(8),
                        width: 400,
                        height: 500,
                        color: Colors.white,
                        child: showImage())),
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
