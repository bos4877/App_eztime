import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Edit_Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Profile_Page extends StatefulWidget {
  Profile_Page({super.key});

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
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  TextEditingController _personStatus = TextEditingController();



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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ProfileHeader(
                avatar: AssetImage('assets/background/person-png-icon-29.jpg'),
                coverImage:
                    AssetImage('assets/background/person-png-icon-29.jpg'),
                title: "ชื่อ-สกุล",
                subtitle: "ตำแหน่ง :",
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
                        builder: (context) => edit_profile(),
                      ));
                    },
                  )
                ],
              ),
              UserInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget UserInfo() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
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
          Card(
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เลขประจำตัวประชาชน',
                        style: TextStyles.pro_file_textStyle,
                      ),
                      Text(
                        '1-2345-6789-12-3',
                        style: TextStyles.pro_file_Style,
                      )
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รหัสพนักงาน',
                        style: TextStyles.pro_file_textStyle,
                      ),
                      Text(
                        '1-2345-6789-12-3',
                        style: TextStyles.pro_file_Style,
                      )
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
  final ImageProvider<dynamic> avatar;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  ProfileHeader(
      {Key? key,
      required this.coverImage,
      required this.avatar,
      required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Avatar(
                image: avatar,
                radius: 60,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 5.0),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  Avatar(
      {Key? key,
      required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 60,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image as ImageProvider<Object>?,
        ),
      ),
    );
  }
}

