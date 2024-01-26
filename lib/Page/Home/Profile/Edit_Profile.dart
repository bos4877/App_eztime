// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/APIServices/EditService/EditProfileService/EditProfileService.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/CustomTextFormField/CustomTextFormField_EditProfile.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<_EditProfileState> editProfileKey =
    GlobalKey<_EditProfileState>();

class edit_profile extends StatefulWidget {
  final id;
  final fname;
  final email;
  final lastName;
  final phone;
  final sex;
  final nationality;
  final bankName;
  final bankNumber;
  final status;
  final birthday;
  edit_profile(
      {Key? key,
      this.id,
      this.fname,
      this.bankName,
      this.bankNumber,
      this.email,
      this.lastName,
      this.nationality,
      this.phone,
      this.sex,
      this.birthday,
      this.status})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<edit_profile> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _lastNameController;
  TextEditingController? _phoneController;
  TextEditingController? _sexController;
  TextEditingController? _nationalityController;
  TextEditingController? _bankController;
  TextEditingController? _bankNumberController;
  TextEditingController? _statusController;
  TextEditingController? _birthdayController;

  XFile? pickedImage;
  String? imagePath;

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePickerHelper.pickImage();
  //   if (pickedFile != null) {
  //     setState(() {
  //       pickedImage = pickedFile;
  //       imagePath = pickedImage!.path;
  //     });
  //   }
  // }

  Future settext() async {

    _nameController = TextEditingController(text: '${widget.fname}');
    _emailController = TextEditingController(text: '${widget.email}');
    _lastNameController = TextEditingController(text: '${widget.lastName}');
    _sexController = TextEditingController(text: '${widget.sex}');
    _nationalityController =
        TextEditingController(text: '${widget.nationality}');
    _phoneController = TextEditingController(text: '${widget.phone}');
    _bankController = TextEditingController(text: '${widget.bankName}');
    _bankNumberController = TextEditingController(text: '${widget.bankNumber}');
    _statusController = TextEditingController(text: '${widget.status}');
    _birthdayController =
        TextEditingController(text: '${widget.birthday.split(' ').first}');
  }

  Future call_Edit_Profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var taken = prefs.getString('_acessToken');
    var service = Edit_Profile_Service();
    try {
      var response = await service.model(
          _nameController!.text,
          _lastNameController!.text,
          _nationalityController!.text,
          _statusController!.text,
          _birthdayController!.text,
          _bankController!.text,
          _bankNumberController!.text,
          _phoneController!.text,
          _emailController!.text,
          taken!,
          widget.id);
      if (response == 200) {
        Dialog_Tang().successdialog(context);
        log('response_Edit_Profile: ${response}');
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    InternetConnectionChecker().checker();
    settext();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _emailController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไขข้อมูล'),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: ElevatedButton(
              child: Text('บันทึก'),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  call_Edit_Profile();
                } else {
                  return;
                }
              },
            )),
        body: Form(
          key: _formkey,
          child: Card(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        pickedImage != null
                            ? Center(
                                child: Image.file(
                                  File(imagePath!),
                                  height: 200,
                                ),
                              )
                            : Text('No Image Selected'),
                        SizedBox(height: 20),
                        Center(
                            child: Buttons(
                                title: 'Pick Image', press: () {
                                  
                                },)),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          section: 'ชื่อ',
                          hintText: 'กรอกชื่อ',
                          controller: _nameController!,
                          validateretrunText: 'กรุณากรอกชื่อ',
                        ),
                        CustomTextFormField(
                            section: 'นามสกุล',
                            hintText: 'กรอกนามสกุล',
                            controller: _lastNameController!,
                            validateretrunText: 'กรุณากรอกนามสกุล'),
                        CustomTextFormField(
                            section: 'วันเกิด',
                            hintText: 'กรอกวันเกิด',
                            controller: _birthdayController!,
                            validateretrunText: 'กรุณากรอกวันเกิด'),
                        CustomTextFormField(
                            section: 'เบอร์โทร',
                            hintText: 'กรอกเบอร์โทร',
                            controller: _phoneController!,
                            validateretrunText: 'กรุณากรอกเบอร์โทร'),
                        CustomTextFormField(
                            section: 'E-Mail',
                            hintText: 'กรอก E-Mail',
                            controller: _emailController!,
                            validateretrunText: 'กรุณากรอก E-Mail'),
                        CustomTextFormField(
                            section: 'เพศ',
                            hintText: 'กรอกเพศ',
                            controller: _sexController!,
                            validateretrunText: 'กรุณากรอกเพศ'),
                        CustomTextFormField(
                            section: 'สัญชาติ',
                            hintText: 'กรอกสัญชาติ',
                            controller: _nationalityController!,
                            validateretrunText: 'กรุณากรอกสัญชาติ'),
                        CustomTextFormField(
                            section: 'ธนาคาร',
                            hintText: 'กรอกธนาคาร',
                            controller: _bankController!,
                            validateretrunText: 'กรุณากรอกธนาคาร'),
                        CustomTextFormField(
                            section: 'เลขบัญชี',
                            hintText: 'กรอกเลขบัญชี',
                            controller: _bankNumberController!,
                            validateretrunText: 'กรุณากรอกเลขบัญชี'),
                        CustomTextFormField(
                            section: 'สถานภาพ',
                            hintText: 'กรอกสถานภาพ',
                            controller: _statusController!,
                            validateretrunText: 'กรุณากรอกสถานภาพ'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
