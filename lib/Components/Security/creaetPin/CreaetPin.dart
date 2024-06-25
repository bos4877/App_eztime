import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Components/menu_page/MyAppbar.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class create_pincode extends StatefulWidget {
  const create_pincode({super.key});

  @override
  State<create_pincode> createState() => _create_pincodeState();
}

class _create_pincodeState extends State<create_pincode> {
  SharedPreferences? prefs;
  final _formKey = GlobalKey<FormState>();
  String _correctPin = ''; // กำหนด PIN ที่ถูกต้อง
  TextEditingController _pinCodeController = TextEditingController();
  bool _isDisposed = false;
  bool obscureText = false;
  bool loading = false;
  @override
  void initState() {
    loading = true;
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 800));
    loading = false;
  }

  void _onKeyPressed(String value) {
    if (!_isDisposed && _pinCodeController.text.length < 4) {
      setState(() {
        _pinCodeController.text += value;
      });
    }
  }

  void _onBackspacePressed() {
    if (!_isDisposed && _pinCodeController.text.isNotEmpty) {
      setState(() {
        _pinCodeController.text = _pinCodeController.text
            .substring(0, _pinCodeController.text.length - 1);
      });
    }
  }

  _onSavePressed() async {
    prefs = await SharedPreferences.getInstance();
    if (_correctPin == null || _correctPin.isEmpty) {
      Snack_Bar(
              snackBarColor: Colors.redAccent,
              snackBarIcon: Icons.warning_rounded,
              snackBarText: 'snackBarText')
          .showSnackBar(context);
    } else {
      var pin = await prefs?.setString('pincode', _correctPin).toString();

      if (pin == null) {
        var isSwitc = prefs?.setBool('isSwitched', false);
      } else {
        var isSwitc = prefs?.setBool('isSwitched', true);
        debugPrint('_correctPin: ${_correctPin}');
        success_dialog(
          detail: 'สร้างรหัสผ่านสำเร็จ',
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenhigth = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              MyAppBar(pagename: 'pagename'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinCodeTextField(
                        obscureText: false,
                        appContext: context,
                        length: 4,
                        controller: _pinCodeController,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.none,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          fieldHeight: 30,
                          fieldWidth: 30,
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          selectedColor: Colors.grey,
                          borderWidth: 1,
                        ),
                        onChanged: (value) {
                          if (value.length == 4) {
                            debugPrint('value: ${value}');
                            _correctPin = value;
                            debugPrint('value: ${_correctPin}');
                          }
                        },
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: screenhigth * 0.5,
                child: CustomKeyboard_createPin(
                  onKeyPressed: _onKeyPressed,
                  onBackspacePressed: _onBackspacePressed,
                  onSavePressed: _onSavePressed,
                ),
              ),
            ],
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }
}

class CustomKeyboard_createPin extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onSavePressed;

  CustomKeyboard_createPin(
      {required this.onKeyPressed,
      required this.onBackspacePressed,
      required this.onSavePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((key) {
            return KeyboardKey_create_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((key) {
            return KeyboardKey_create_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((key) {
            return KeyboardKey_create_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyboardKey_create_pincode(
              label: '✓',
              onPressed: onSavePressed,
            ),
            KeyboardKey_create_pincode(
              label: '0',
              onPressed: () => onKeyPressed('0'),
            ),
            KeyboardKey_create_pincode(
              label: '⌫',
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class KeyboardKey_create_pincode extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  KeyboardKey_create_pincode({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var screenhigth = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8.0),
        width: screenwidth * 0.2,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: label == 'C' || label == '✓'
                    ? Colors.blue
                    : label == '⌫'
                        ? Colors.redAccent
                        : Colors.black),
          ),
        ),
      ),
    );
  }
}
