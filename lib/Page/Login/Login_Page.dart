// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_unnecessary_containers, unused_local_variable
import 'dart:ffi';
import 'package:eztime_app/Components/Background/Background.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/load/loaddialog.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;
  SharedPreferences? pref;
  var _isObscured;

  @override
  void initState() {
    _isObscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:  SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: MediaQuery.of(context).size.height * 0.35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Image(
                        image: AssetImage('assets/background/Asset_1.png'),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // obscureText: true,
                        scrollPadding: EdgeInsets.all(10),
                        controller: _email,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Colors.blue,
                          ),
                          labelText: "อีเมล",
                          labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกอีเมล!!';
                          }
                          //return null;
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        obscureText: _isObscured,
                        controller: _password,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(
                            Icons.key_rounded,
                            color: Colors.blue,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: _isObscured
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: Colors.blue,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    )),
                          labelText: "รหัสผ่าน",
                          labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน!!';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Buttons(
                        title: 'เข้าสู่ระบบ',
                        press: () async {
                          // await dologin(username.text, password.text);
                          await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => BottomNavigationBar_Page()));
                                   
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'หากยังไม่ได้เป็นสมาชิก HIP EASY TIME?',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent), // เซ็ตสี overlay เป็นโปร่งใส
                          ),
                          onPressed: () {},
                          child: Text('กรุณาลงทะเบียน'),
                        )
                      ],
                    ),
                    loading ? Loading() : Container()
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
