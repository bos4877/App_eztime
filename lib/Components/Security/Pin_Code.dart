import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> with SingleTickerProviderStateMixin {
  bool loading = false;
  TextEditingController _pinCodeController = TextEditingController();
   AnimationController? _animationController;
  final _formKey = GlobalKey<FormState>();
   String _correctPin = ''; // กำหนด PIN ที่ถูกต้อง
  bool _isDisposed = false;
  bool obscureText = false;
@override
  void initState() {
    loading = true;
    // TODO: implement initState
    super.initState();
    loaddata();
        _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
  }
  @override
  void dispose() {
    _pinCodeController.dispose();
    _isDisposed = true;
      _animationController?.dispose();
    super.dispose();
  }
 Future loaddata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _correctPin = prefs.getString('pincode')!;
    setState(() {
       loading = false;
    });
   
  }


  void _submitPinCode() {
   setState(() {
      loading = true ;
   });
    if (_pinCodeController.text == _correctPin) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home_Page(),
            ),
            (route) => false);
            loading = false;
      });

      // Navigate to the next screen or perform your logic
    } else {
      setState(() {
         _animationController?.forward(from: 0);
         loading = false;
         _pinCodeController.clear();
      });
      Snack_Bar(
              snackBarColor: Colors.redAccent,
              snackBarIcon: Icons.warning_amber,
              snackBarText: 'รหัสผ่านผิด')
          .showSnackBar(context);
    }
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

  void _onClearPressed() {
    if (!_isDisposed) {
      setState(() {
        _pinCodeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenwith = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter PIN Code'),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenwith * 0.3),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  final offset = 10 * (1 - _animationController!.value);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child:  PinCodeTextField(
                        obscureText: obscureText,
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
                          if (value != null || value.isNotEmpty) {
                            setState(() {
                              obscureText = true;
                            });
                          } else {
                            setState(() {
                              obscureText = false;
                            });
                          }
                          if (value.length == 4) {
                            setState(() {
                              loading = true;
                              _submitPinCode();
                            });
                          }
                        },
                      ),
                  );
                },),
                     
                      // SizedBox(height: 20),
                      SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: ,
                      //   child: Text('Submit'),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              CustomKeyboard(
                onKeyPressed: _onKeyPressed,
                onBackspacePressed: _onBackspacePressed,
                onClearPressed: _onClearPressed,
              ),
            ],
          ),
        ),
        loading
            ? Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                      strokeWidth: 5.0,
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;

  CustomKeyboard(
      {required this.onKeyPressed,
      required this.onBackspacePressed,
      required this.onClearPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((key) {
            return KeyboardKey_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((key) {
            return KeyboardKey_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((key) {
            return KeyboardKey_pincode(
              label: key,
              onPressed: () => onKeyPressed(key),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyboardKey_pincode(
              label: 'C',
              onPressed: onClearPressed,
            ),
            KeyboardKey_pincode(
              label: '0',
              onPressed: () => onKeyPressed('0'),
            ),
            KeyboardKey_pincode(
              label: '⌫',
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class KeyboardKey_pincode extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  KeyboardKey_pincode({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8.0),
        width: 60,
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
                color: label == 'C'
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
