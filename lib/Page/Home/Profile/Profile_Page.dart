// ignore_for_file: unused_import, unnecessary_null_comparison
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/DiaLog/load/card_loader/card_loading.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:eztime_app/Model/Get_Model/get_Profile/Profile_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Edit_Profile.dart';
import 'package:eztime_app/controller/APIServices/ProFileServices/ProfileService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile_Page extends StatefulWidget {
  final images;
  Profile_Page({super.key, this.images});
  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  bool loading = false;
  bool _cancel = false;
  Profile_Model _profilelist = Profile_Model();
  var service = get_profile_service();

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getprofile() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('_acessToken');
      var response = await service.getprofile(token);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        log(response.toString());
        if (response == DioException) {
          Dialog_notdata.showCustomDialog(context);
          log('faile');
          setState(() {
            loading = false;
          });
        } else {
          _profilelist.employData = response ?? [];
          log('success');
          setState(() {
            loading = false;
          });
        }
      });
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getprofile();
  }

  onGoback() async {
    setState(() {
      loading = true;
    });
    await getprofile();
    setState(() {
      loading = false;
    });
  }

  onRefresh() async {
    setState(() {
      loading = true;
    });
    await getprofile();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
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
              child: Stack(
                children: [
                  MyAppBar(pagename: 'Profile.title'),
                  _profilelist.employData?.image == null ||
                          _profilelist.employData!.image!.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: size * 0.2),
                          child: Profile_noimages(),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: size * 0.2),
                          child: ProfileHeader(
                              load: loading,
                              coverImage: NetworkImage(
                                  '${_profilelist.employData?.image}'),
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => edit_profile(
                                        first_name:
                                            '${_profilelist.employData!.firstName}',
                                        last_name:
                                            '${_profilelist.employData!.lastName}',
                                        sex: '${_profilelist.employData!.sex}',
                                        phone:
                                            '${_profilelist.employData!.phone}',
                                        bank_name:
                                            '${_profilelist.employData!.bankName}',
                                        bank_no:
                                            '${_profilelist.employData!.bankNo}',
                                        birth_day:
                                            '${_profilelist.employData!.birthDay}',
                                        email:
                                            '${_profilelist.employData!.email}',
                                        nationality:
                                            '${_profilelist.employData!.nationality}',
                                        status:
                                            '${_profilelist.employData!.status}',
                                      ),
                                    ))
                                        .then((value) {
                                      if (value == null) {
                                        onGoback();
                                      } else {
                                        onGoback();
                                      }
                                    });
                                  },
                                ),
                              ]),
                        ),
                  card_loading_CPN(
                    loading: loading,
                    chid: Padding(
                      padding: EdgeInsets.only(
                          top: size * 0.55, bottom: 0, left: 0, right: 0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8.0, bottom: 5),
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
                ],
              ),
            ),
          ),
        ),
        loading ? LoadingComponent() : Container(),
      ],
    );
  }

  Widget UserInfo() {
    return Container(
      color: Colors.white,
      child: card_loading_CPN(
        loading: loading,
        chid: ListView(
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          children: [
            colum_tang(
                section: 'Profile.employeeIdName',
                data:
                    '${_profilelist.employData?.firstName} ${_profilelist.employData?.lastName}'),
            colum_tang(
                section: 'Profile.nickname',
                data: '${_profilelist.employData?.nickname}'),
            colum_tang(
                section: 'Profile.employeeIdCard',
                data: '${_profilelist.employData?.idCard}'),
            colum_tang(
                section: 'Profile.Mobile_number',
                data: '${_profilelist.employData?.phone}'),
            colum_tang(
                section: 'Profile.Email',
                data: '${_profilelist.employData?.email}'),
            colum_tang(
                section: 'Profile.Job_placement',
                data: '${_profilelist.employData?.passedDate}'),
            colum_tang(
                section: 'Profile.Employee_type',
                data: '${_profilelist.employData?.employeeType}'),
            colum_tang(
                section: 'Profile.Gender',
                data: '${_profilelist.employData?.sex}'),
            colum_tang(
                section: 'Profile.nationality',
                data: '${_profilelist.employData?.nationality}'),
            colum_tang(
                section: 'Profile.birthday',
                data: '${_profilelist.employData?.birthDay?.split(' ').first}'),
            colum_tang(
                section: 'Profile.status',
                data: '${_profilelist.employData?.status}'),

            colum_tang(
                section: 'Profile.salary',
                data: '${_profilelist.employData?.salary}'),
            colum_tang(
                section: 'Profile.Starting_day',
                data:
                    '${_profilelist.employData?.startedDate?.split('T').first}'),
            colum_tang(
                section: 'Profile.tax',
                data: _profilelist.employData?.vatId == null
                    ? 'Profile.Not_data'
                    : '${_profilelist.employData?.vatId}'),
            colum_tang(
                section: 'Profile.bank',
                data: '${_profilelist.employData?.bankName}'),
            colum_tang(
                section: 'Profile.bank_number',
                data: '${_profilelist.employData?.bankNo}'),
          ],
        ),
      ),
    );
  }

  Widget Profile_noimages() {
    return card_loading_CPN(
      loading: loading,
      chid: ProfileHeader(
        load: true,
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
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => edit_profile(
                  first_name: '${_profilelist.employData!.firstName}',
                  last_name: '${_profilelist.employData!.lastName}',
                  sex: '${_profilelist.employData!.sex}',
                  phone: '${_profilelist.employData!.phone}',
                  bank_name: '${_profilelist.employData!.bankName}',
                  bank_no: '${_profilelist.employData!.bankNo}',
                  birth_day: '${_profilelist.employData!.birthDay}',
                  email: '${_profilelist.employData!.email}',
                  nationality: '${_profilelist.employData!.nationality}',
                  status: '${_profilelist.employData!.status}',
                ),
              ))
                  .then((value) {
                if (value == null) {
                  onGoback();
                } else {
                  onGoback();
                }
              });
            },
          )
        ],
      ),
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
  final bool load;
  ProfileHeader(
      {Key? key,
      required this.coverImage,
      required this.load,
      this.actions,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 115,
      this.borderWidth = 2.5})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: load,
      enableSwitchAnimation: true,
      child: Column(
        children: <Widget>[
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
      ),
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
