import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:flutter/material.dart';

class reset_password extends StatefulWidget {
  const reset_password({super.key});

  @override
  State<reset_password> createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  TextEditingController form = TextEditingController();
  TextEditingController form1 = TextEditingController();
  TextEditingController form2 = TextEditingController();
  bool _obscureText = false;
  bool _obscureText1 = false;
  bool _obscureText2 = false;

  @override
  void initState() {
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
        press: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              width: 250,
              height: 40,
              child: TextFormField(
                controller: form,
                cursorWidth: 1.5,
                cursorHeight: 20,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'changePass.Password'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText; // เปลี่ยนค่าการซ่อนข้อความ
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 40,
              child: TextFormField(
                controller: form1,
                cursorWidth: 1.5,
                cursorHeight: 20,
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'changePass.NewPassword'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText1 =
                            !_obscureText1; // เปลี่ยนค่าการซ่อนข้อความ
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 40,
              child: TextFormField(
                controller: form2,
                cursorWidth: 1.5,
                cursorHeight: 20,
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'changePass.ConfirmPassword'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText2 =
                            !_obscureText2; // เปลี่ยนค่าการซ่อนข้อความ
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
