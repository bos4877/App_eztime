// ignore_for_file: unused_import
import 'dart:developer';

import 'package:eztime_app/Components/APIServices/ProFileServices/ProfileService.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:eztime_app/Model/Profile/Profile_Model.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Edit_Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  TextEditingController _address = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _apersonnum = TextEditingController();
  TextEditingController _personStatus = TextEditingController();
  List<EmployData> _profilelist = [];
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
        if (response == null) {
          // Dialog_Tang().dialog(context,);
          setState(() {
            load = false;
          });
        } else {
          _profilelist = [response];
          setState(() {
            load = false;
          });
        }
      });
    } catch (e) {
      // Dialog_Tang().dialog(context);
    }
  }

  @override
  void initState() {
    InternetConnectionChecker().checker();
    getprofile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลพนักงาน'),
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
                  title: 'บันทึก',
                  press: () {
                    setState(() {
                      _cancel = false;
                    });
                  }),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          ProfileHeader(
            coverImage: NetworkImage(
                'https://www.khaosod.co.th/wpapp/uploads/2022/02/%E0%B8%9E%E0%B8%9B%E0%B8%8A%E0%B8%A3.%E0%B9%80%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD.jpg'),
            actions: [
              MaterialButton(
                color: Colors.blue,
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
                      fname: _profilelist[0].firstName,
                      bankName: _profilelist[0].bankName,
                      bankNumber: _profilelist[0].bankNo,
                      email: _profilelist[0].email,
                      lastName: _profilelist[0].lastName,
                      nationality: _profilelist[0].nationality,
                      phone: _profilelist[0].phone,
                      sex: _profilelist[0].sex,
                      status: _profilelist[0].status,
                      birthday: _profilelist[0].birthDay,
                      id: _profilelist[0].employeeNo,
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
              "ข้อมูลทั่วไป",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(child: UserInfo()),
        ],
      ),

      //   ),
      // ),
    );
  }

  Widget UserInfo() {
    return load
        ? Loading()
        : Container(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    colum_tang(
                        section: 'ชื่อ - นามสกุล',
                        data:
                            '${_profilelist[0].firstName} ${_profilelist[0].lastName}'),
                    colum_tang(
                        section: 'รหัสพนักงาน',
                        data: '${_profilelist[0].employeeNo}'),
                    colum_tang(
                        section: 'เลขประจำตัวประชาชน',
                        data: '${_profilelist[0].personalId}'),
                    colum_tang(
                        section: 'มือถือ', data: '${_profilelist[0].phone}'),
                    colum_tang(
                        section: 'E-Mail', data: '${_profilelist[0].email}'),
                    colum_tang(section: 'เพศ', data: '${_profilelist[0].sex}'),
                    colum_tang(
                        section: 'สัญชาติ',
                        data: '${_profilelist[0].nationality}'),
                    colum_tang(
                        section: 'วันเกิด',
                        data: '${_profilelist[0].birthDay!.split(' ').first}'),
                    colum_tang(
                        section: 'สถานะ', data: '${_profilelist[0].status}'),
                    colum_tang(
                        section: 'บริษัท',
                        data: '${_profilelist[0].branchOffice}'),
                    colum_tang(
                        section: 'แผนก', data: '${_profilelist[0].department}'),
                    colum_tang(
                        section: 'ตำแหน่ง',
                        data: '${_profilelist[0].position}'),
                    colum_tang(
                        section: 'ประเภทพนักงาน',
                        data: '${_profilelist[0].employeeType}'),
                    colum_tang(
                        section: 'เงินเดือน',
                        data: '${_profilelist[0].salary}'),
                    colum_tang(
                        section: 'วันเริ่มทำงาน',
                        data:
                            '${_profilelist[0].startedDate!.split('T').first}'),
                    colum_tang(section: 'วันที่บรรจุ', data: ''),
                    colum_tang(
                        section: 'ภาษี',
                        data: _profilelist[0].vatId == null
                            ? 'ไม่มีข้อมูล'
                            : '${_profilelist[0].vatId}'),
                    //  colum_tang(section: 'ช่องทางชำระเงิน', data: _profilelist[0].finger == null ? 'ไม่มีข้อมูล':'${_profilelist[0].}'),
                    colum_tang(
                        section: 'ธนาคาร', data: '${_profilelist[0].bankName}'),
                    colum_tang(
                        section: 'เลขบัญชี', data: '${_profilelist[0].bankNo}'),
                  ],
                ),
              ),
            ));
  }

  Widget EditUserInfo() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "ข้อมูลส่วนบุคคล",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          TextField(
                            controller: _address,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.my_location,
                              ),
                              labelText: "ที่อยู่",
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextField(
                            controller: _phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                              ),
                              labelText: "เบอร์โทร",
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextField(
                            controller: _apersonnum,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                              labelText: "รหัสพนักงาน",
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget more() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.grey[200],
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        child: ExpansionTile(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          backgroundColor: Colors.grey[200],
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/align-left-svgrepo.svg',
                color: Colors.grey,
              ),
              // Image.asset('assets/icons/align-left-svgrepo.svg'),
              SizedBox(
                width: 5,
              ),
              Text(
                'ข้อมูลทั้งหมด',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // onExpansionChanged: (expanded) {
          //   setState(() {
          //     expanded = false;
          //   });
          // },
          children: [
            TextFormField(
              controller: _personStatus,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.align_horizontal_left_sharp,
                ),
                labelText: "สถานะพนักงาน",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Editmore() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.grey[200],
        child: ExpansionTile(
          backgroundColor: Colors.grey[200],
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/align-left-svgrepo.svg',
                color: Colors.grey,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'ข้อมูลทั้งหมด',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          children: [
            TextField(
              controller: _personStatus,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.align_horizontal_left_sharp,
                ),
                labelText: "สถานะพนักงาน",
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
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
      this.borderWidth = 5})
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
            radius: radius,
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: radius - borderWidth,
              backgroundImage: coverImage as ImageProvider<Object>?,
            ),
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
        ),
        Text(
          data,
          style: TextStyles.pro_file_Style,
        ),
        Divider(),
      ],
    );
  }
}
