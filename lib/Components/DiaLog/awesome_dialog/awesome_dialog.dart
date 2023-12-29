import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class Dialog_Tang extends StatelessWidget {
  Dialog_Tang({
    super.key,
  });
  errordialog(BuildContext context,) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'แจ้งเตือน',
      desc: '',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }
    successdialog(BuildContext context,) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'แจ้งเตือน',
      desc: 'บันทึกสำเร็จ',
      
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
