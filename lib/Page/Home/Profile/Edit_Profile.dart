import 'dart:io';

import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/Page/Home/promble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final GlobalKey<_EditProfileState> editProfileKey =
    GlobalKey<_EditProfileState>();

class edit_profile extends StatefulWidget {
  edit_profile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<edit_profile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  XFile? pickedImage;
  String? imagePath;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerHelper.pickImage();

    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
         imagePath = pickedImage!.path;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไขข้อมูล'),
        ),
        floatingActionButton: Buttons(
          title: 'บันทึก',
          press: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Card(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pickedImage != null
                        ? Image.file(
                            imagePath as File,
                            height: 200,
                          )
                        : Text('No Image Selected'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    Text(
                      'เลขประจำตัวประชาชน',
                      style: TextStyles.setting_Style,
                    ),
                    CustomTextFormField(
                        hintText: 'เลขประจำตัวประชาชน',
                        controller: _nameController),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'เลขประจำตัวประชาชน',
                      style: TextStyles.setting_Style,
                    ),
                    CustomTextFormField(
                        hintText: 'เลขประจำตัวประชาชน',
                        controller: _nameController),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomTextFormField({
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: TextFormField(
        autocorrect: false,
        enableIMEPersonalizedLearning: false,
        cursorWidth: 1,
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            hintStyle: TextStyles.pro_file_Style),
      ),
    );
  }
}
