// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Pin_code_Compl {
  InputController _inputController = InputController();
  var status;
   Future<void> picode(BuildContext context){
    return screenLockCreate(
  context: context,
  title: const Text('Create Pincode',style: TextStyle(color: Colors.black),),
  confirmTitle: const Text('confirm Pin',style: TextStyle(color: Colors.black),),
  inputController: _inputController,
  onConfirmed: (value) async{
    print('value: ${value}');
    SharedPreferences
     prefs = await SharedPreferences.getInstance();
    status = _inputController.currentInput.value;
    if (status == null) {
      return null;
    } else {
       prefs.setString('pincode', _inputController.currentInput.value);
       Navigator.of(context).pop();
      return status;
    }
    // Navigator.of(context).pop();
    // return status;
  },
  config: const ScreenLockConfig(
    backgroundColor: Colors.white,
    buttonStyle: ButtonStyle(iconColor: MaterialStatePropertyAll(Colors.red))

  ),
  secretsConfig: SecretsConfig(
    spacing: 15, // or spacingRatio
    padding: const EdgeInsets.all(40),
    secretConfig: SecretConfig(
      borderColor: Colors.grey,
      borderSize: 2.0,
      disabledColor: Colors.grey,
      enabledColor: Colors.blue,
      size: 15,
builder:(context, config, enabled) {
  return Container( 
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: enabled
              ? config.enabledColor
              : config.disabledColor,
          border: Border.all(
            width: config.borderSize,
            color: config.borderColor,
          ),
        ),
        padding:  EdgeInsets.all(10),
        width: config.size,
        height: config.size,
      );  
}
    ),
  ),


  keyPadConfig: KeyPadConfig(
    buttonConfig: KeyPadButtonConfig(
    ),
    displayStrings: [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ],
  ),
  cancelButton: const Icon(Icons.cancel_rounded,size: 30,color: Colors.red),

  // deleteButton: const Icon(Icons.backspace_outlined,color: Colors.blueAccent),

);
}
}