// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/Custom/CustomTextFormField/CustomTextFormField_EditProfile.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Edit_Profile_Model.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/EditService/EditProfileService/EditProfileService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

final GlobalKey<_EditProfileState> editProfileKey =
    GlobalKey<_EditProfileState>();

class edit_profile extends StatefulWidget {
  String first_name;
  String last_name;
  String sex;
  String nationality;
  String status;
  String birth_day;
  String bank_name;
  String bank_no;
  String phone;
  String email;

  edit_profile({
    Key? key,
    required this.first_name,
    required this.last_name,
    required this.sex,
    required this.nationality,
    required this.status,
    required this.birth_day,
    required this.bank_name,
    required this.bank_no,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<edit_profile> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _bankController = TextEditingController();
  TextEditingController _bankNumberController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();

  XFile? pickedImage;
  String? imagePath;
  String? imagePathname;
  bool loaddialog = false;
  Edit_Profile_Model _editList = Edit_Profile_Model();
  var token;
  var id;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePickerHelper.pickImage(ImageSource.gallery, 20);
    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
        imagePath = pickedImage!.path;
        imagePathname = pickedImage!.name;
      });
    }
  }

  Future _settextedit() async {
    setState(() {
      loaddialog = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await Future.delayed(Duration(seconds: 1));
    _nameController = await TextEditingController(text: '${widget.first_name}');
    _emailController = await TextEditingController(text: '${widget.email}');
    _lastNameController =
        await TextEditingController(text: '${widget.last_name}');
    _phoneController = await TextEditingController(text: '${widget.phone}');
    _sexController = await TextEditingController(text: '${widget.sex}');
    _nationalityController =
        await TextEditingController(text: '${widget.nationality}');
    _bankController = await TextEditingController(text: '${widget.bank_name}');
    _bankNumberController =
        await TextEditingController(text: '${widget.bank_no}');
    _birthdayController = await TextEditingController(
        text: '${widget.birth_day.split('T').first}');
    setState(() {
      loaddialog = false;
    });
  }

  Future call_Edit_Profile() async {
    setState(() {
      loaddialog = true;
    });

    try {
      String url = '${connect_api().domain}/edit_employee';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      if (imagePath == null ||
          imagePath!.isEmpty ||
          imagePathname == null ||
          imagePathname!.isEmpty) {
        request.fields['first_name'] = _nameController!.text;
        request.fields['last_name'] = _lastNameController!.text;
        request.fields['sex'] = _sexController!.text;
        request.fields['nationality'] = _nationalityController!.text;
        request.fields['birth_day'] = _birthdayController!.text;
        request.fields['bank_name'] = _bankController!.text;
        request.fields['bank_no'] = _bankNumberController!.text;
        request.fields['phone'] = _phoneController!.text;
        request.fields['email'] = _emailController!.text;
        request.fields['image'] = '';
        request.headers['Authorization'] = 'Bearer $token';
      } else {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          imagePath!,
          filename: imagePathname,
        );
        request.files.add(multipartFile);
        request.fields['first_name'] = _nameController!.text;
        request.fields['last_name'] = _lastNameController!.text;
        request.fields['sex'] = _sexController!.text;
        request.fields['nationality'] = _nationalityController!.text;
        request.fields['birth_day'] = _birthdayController!.text;
        request.fields['bank_name'] = _bankController!.text;
        request.fields['bank_no'] = _bankNumberController!.text;
        request.fields['phone'] = _phoneController!.text;
        request.fields['email'] = _emailController!.text;
        request.headers['Authorization'] = 'Bearer $token';
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {
        if (response.statusCode == 200) {
          loaddialog = false;
          Dialog_Success.showCustomDialog(context);
          log('response_Edit_Profile: ${response}');
          loaddialog = false;
        } else {
          Dialog_false.showCustomDialog(context);
          log(response.body.toString());
          loaddialog = false;
        }
      });
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    } finally {
      setState(() {
        loaddialog = false;
      });
    }
  }

  @override
  void initState() {
    loaddialog = true;
    _settextedit();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
            bottomNavigationBar: loaddialog
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3,
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    child: Buttons(
                      title: 'buttons.Save',
                      press: () {
                        if (_formkey.currentState!.validate()) {
                          call_Edit_Profile();
                        } else {
                          return;
                        }
                      },
                    )),
            body: Form(
              key: _formkey,
              child: Stack(
                children: [
                  MyAppBar(pagename: 'Edit_profile.title'),
                  card_loading_CPN(
                    loading: loaddialog,
                    chid: Padding(
                      padding: EdgeInsets.only(top: size * 0.2),
                      child: ListView(
                        children: [
                          Skeletonizer(
                            enabled: loaddialog,
                            enableSwitchAnimation: true,
                            child: Padding(
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
                                        : Center(
                                            child: Text(
                                                'Edit_profile.No Image Selected'
                                                    .tr())),
                                    SizedBox(height: 20),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: Center(
                                          child: loaddialog
                                              ? SizedBox()
                                              : Buttons(
                                                  title:
                                                      'Edit_profile.Select Image',
                                                  press: () {
                                                    _pickImage();
                                                  },
                                                )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                        load: loaddialog,
                                        section: 'Edit_profile.name',
                                        hintText: 'validateEdit.validatName',
                                        controller: _nameController,
                                        validateretrunText:
                                            'validateEdit.validatName',
                                      ),
                                    ),
                                    Skeletonizer(
                                      enabled: loaddialog,
                                      child: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.lastname',
                                          hintText:
                                              'validateEdit.validatlastName',
                                          controller: _lastNameController,
                                          validateretrunText:
                                              'validateEdit.validatlastName'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.birthday',
                                          hintText:
                                              'validateEdit.validatbirthday',
                                          controller: _birthdayController,
                                          validateretrunText:
                                              'validateEdit.validatbirthday'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.Phone',
                                          hintText: 'validateEdit.validatPhone',
                                          controller: _phoneController,
                                          validateretrunText:
                                              'validateEdit.validatPhone'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.email',
                                          hintText:
                                              'validateEdit.validateEmail',
                                          controller: _emailController,
                                          validateretrunText:
                                              'validateEdit.validateEmail'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.gender',
                                          hintText:
                                              'validateEdit.validategender',
                                          controller: _sexController,
                                          validateretrunText:
                                              'validateEdit.validategender'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.nationality',
                                          hintText:
                                              'validateEdit.validatenationality',
                                          controller: _nationalityController,
                                          validateretrunText:
                                              'validateEdit.validatenationality'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.bank',
                                          hintText: 'validateEdit.Validatebank',
                                          controller: _bankController,
                                          validateretrunText:
                                              'validateEdit.Validatebank'),
                                    ),
                                    card_loading_CPN(
                                      loading: loaddialog,
                                      chid: CustomTextFormField(
                                          load: loaddialog,
                                          section: 'Edit_profile.bank_number',
                                          hintText:
                                              'validateEdit.Validatebank_number',
                                          controller: _bankNumberController,
                                          validateretrunText:
                                              'validateEdit.Validatebank_number'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        loaddialog ? LoadingComponent() : SizedBox()
      ],
    );
  }
}
