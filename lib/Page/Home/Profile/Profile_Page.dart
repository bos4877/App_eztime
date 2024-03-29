// ignore_for_file: unused_import
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Edit_Profile.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile_Page extends StatefulWidget {
  final images;
  Profile_Page({super.key, this.images});
  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  bool load = false;
  bool _cancel = false;
  Profile_Model _profilelist = Profile_Model();
  var service = get_profile_service();

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getprofile() async {
    setState(() {
      load = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('_acessToken');
      var response = await service.getprofile(token);
      setState(() {
        log(response.toString());
        if (response == null) {
          Dialog_notdata.showCustomDialog(context);
          log('faile');
          setState(() {
            load = false;
          });
        } else {
          _profilelist.employData = response;
          log('success');
          setState(() {
            load = false;
          });
        }
      });
    } catch (e) {
      load = false;

      log(e.toString());
      // Dialog_Tang().dialog(context);
    }
  }

  @override
  void initState() {
    getprofile();
    // TODO: implement initState
    super.initState();
  }
  onRefresh()async{
    setState(() {
      load = true;
    });
await getprofile();
     setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? LoadingComponent()
        : Scaffold(
            appBar: AppBar(
              title: Text('Profile.title').tr(),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            floatingActionButton: _cancel
                ? Material(
                    elevation: 5,
                    color: Colors.transparent,
                    child: Buttons(
                        title: 'buttons.Save',
                        press: () {
                          setState(() {
                            _cancel = false;
                          });
                        }),
                  )
                : Container(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Center(
              child: RefreshIndicator(
                onRefresh: () => onRefresh(),
                child: Column(
                  children: [
                    _profilelist.employData!.image == null || _profilelist.employData!.image!.isEmpty
                        ? Profile_noimages()
                        : ProfileHeader(
                            coverImage: NetworkImage('${_profilelist.employData!.image}'),
                            actions: [
                              MaterialButton(
                                color: Theme.of(context).primaryColor,
                                shape: CircleBorder(),
                                elevation: 0,
                                child: _cancel
                                    ? Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => edit_profile(
                                      first_name:'${_profilelist.employData!.firstName}',
                                      last_name:'${_profilelist.employData!.lastName}' ,
                                      sex:'${_profilelist.employData!.sex}' ,
                                      phone:'${_profilelist.employData!.phone}' ,
                                      bank_name:'${_profilelist.employData!.bankName}' ,
                                      bank_no:'${_profilelist.employData!.bankNo}' ,
                                      birth_day:'${_profilelist.employData!.birthDay}' ,
                                      email:'${_profilelist.employData!.email}' ,
                                      nationality:'${_profilelist.employData!.nationality}' ,
                                      status:'${_profilelist.employData!.status}' ,
                                    ),
                                  ));
                                },
                              )
                            ],
                          ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Profile.General_information",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ).tr(),
                    ),
                    Expanded(child: UserInfo()),
                  ],
                ),
              ),
            ),
          );
  }

  Widget UserInfo() {
    return load
        ? LoadingComponent()
        : Container(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    colum_tang(
                        section: 'Profile.employeeIdName',
                        data:
                            '${_profilelist.employData!.firstName} ${_profilelist.employData!.lastName}'),
                    colum_tang(
                        section: 'Profile.nickname',
                        data: '${_profilelist.employData!.nickname}'),
                    // colum_tang(
                    //     section: 'Profile.employeeId',
                    //     data: '${_profilelist.idCard}'),
                    colum_tang(
                        section: 'Profile.employeeIdCard',
                        data: '${_profilelist.employData!.idCard}'),
                    colum_tang(
                        section: 'Profile.Mobile_number',
                        data: '${_profilelist.employData!.phone}'),
                    colum_tang(
                        section: 'Profile.Email',
                        data: '${_profilelist.employData!.email}'),
                         colum_tang(
                        section: 'วันที่บรรจุ',
                        data: '${_profilelist.employData!.passedDate}'),
                        colum_tang(
                        section: 'ประเภทพนักงาน',
                        data: '${_profilelist.employData!.employeeType}'),
                    colum_tang(
                        section: 'Profile.Gender', data: '${_profilelist.employData!.sex}'),
                    colum_tang(
                        section: 'Profile.nationality',
                        data: '${_profilelist.employData!.nationality}'),
                    colum_tang(
                        section: 'Profile.birthday',
                        data: '${_profilelist.employData!.birthDay!.split(' ').first}'),
                    colum_tang(
                        section: 'Profile.status',
                        data: '${_profilelist.employData!.status}'),
                        
                    colum_tang(
                        section: 'Profile.salary',
                        data: '${_profilelist.employData!.salary}'),
                    colum_tang(
                        section: 'Profile.Starting_day',
                        data: '${_profilelist.employData!.startedDate!.split('T').first}'),
                    colum_tang(
                        section: 'Profile.tax',
                        data: _profilelist.employData!.vatId == null
                            ? 'Profile.Not_data'
                            : '${_profilelist.employData!.vatId}'),
                    colum_tang(
                        section: 'Profile.bank',
                        data: '${_profilelist.employData!.bankName}'),
                    colum_tang(
                        section: 'Profile.bank_number',
                        data: '${_profilelist.employData!.bankNo}'),
                        
                  ],
                ),
              ),
            ));
  }

  Widget Profile_noimages() {
    return ProfileHeader(
      coverImage: AssetImage('assets/images/unknown_images.png'),
      actions: [
        MaterialButton(
          color: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          elevation: 0,
          child: _cancel
              ? Icon(
                  Icons.cancel,
                  color: Colors.white,
                )
              : Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => edit_profile(
                  first_name:'${_profilelist.employData!.firstName}',
                                      last_name:'${_profilelist.employData!.lastName}' ,
                                      sex:'${_profilelist.employData!.sex}' ,
                                      phone:'${_profilelist.employData!.phone}' ,
                                      bank_name:'${_profilelist.employData!.bankName}' ,
                                      bank_no:'${_profilelist.employData!.bankNo}' ,
                                      birth_day:'${_profilelist.employData!.birthDay}' ,
                                      email:'${_profilelist.employData!.email}' ,
                                      nationality:'${_profilelist.employData!.nationality}' ,
                                      status:'${_profilelist.employData!.status}' ,
              ),
            ));
          },
        )
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider coverImage;
  final Color borderColor;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  ProfileHeader(
      {Key? key,
      required this.coverImage,
      this.actions,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 100,
      this.borderWidth = 2.5})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
            child: CircleAvatar(
          radius: radius + borderWidth,
          backgroundColor: borderColor,
          child: CircleAvatar(
            backgroundColor: borderColor,
            radius: radius - borderWidth,
            backgroundImage: coverImage,
          ),
        )),
        if (actions != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
      ],
    );
  }
}

class colum_tang extends StatelessWidget {
  final String section;
  final String data;
  const colum_tang({super.key, required this.section, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section,
          style: TextStyles.pro_file_textStyle,
        ).tr(),
        Text(
         data == null || data.isEmpty ? 'ไม่พบข้อมูล' : data,
          style: TextStyles.pro_file_Style,
        ),
        Divider(),
      ],
    );
  }
}
