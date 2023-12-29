import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';

class reset_password extends StatefulWidget {
  const reset_password({super.key});

  @override
  State<reset_password> createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController form = TextEditingController();
  TextEditingController form1 = TextEditingController();
  TextEditingController form2 = TextEditingController();
  bool _obscureText = false;
  bool _obscureText1 = false;
  bool _obscureText2 = false;

  @override
  void initState() {
    InternetConnectionChecker().checker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('changePass.title').tr(),
      ),
      floatingActionButton: Buttons(
        title: 'buttons.Save'.tr(),
        press: () {
          if (_formkey.currentState!.validate()) {
            
          }
        },
      ),
      key: _formkey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: form,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
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
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: _obscureText
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )),
                      labelText: "รหัสผ่านเดิม",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่านเดิม!!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: TextFormField(
                    obscureText: _obscureText1,
                    controller: form1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
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
                              _obscureText1 = !_obscureText1;
                            });
                          },
                          icon: _obscureText1
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )),
                      labelText: "รหัสผ่านใหม่",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่านใหม่!!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: TextFormField(
                    obscureText: _obscureText2,
                    controller: form2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
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
                              _obscureText2 = !_obscureText2;
                            });
                          },
                          icon: _obscureText2
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )),
                      labelText: "ยืนยันรหัสผ่านใหม่",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่านใหม่!!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    
  }
}
