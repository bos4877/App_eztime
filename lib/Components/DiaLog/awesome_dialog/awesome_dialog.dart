import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class Dialog_Tang extends StatelessWidget {
  Dialog_Tang({
    super.key,
  });
  errordialog(
    BuildContext context,
  ) {
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

  successdialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'แจ้งเตือน',
      desc: 'บันทึกสำเร็จ',
      autoHide: Duration(seconds: 2),
      dismissOnTouchOutside: false,
      onDismissCallback: (type) {
        Navigator.of(context).pop(type);
      },
    )..show();
  }

  falsedialog(
    BuildContext context,
  ) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'แจ้งเตือน',
        desc: 'บันทึกไม่สำเร็จ',
        dismissOnTouchOutside: false,
        autoHide: Duration(seconds: 2))
      ..show();
  }

  infodialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'แจ้งเตือน',
      desc: 'ไม่พบข้อมูล',
      barrierColor: Colors.grey,
      autoDismiss: true,
      onDismissCallback: (type) {
        Navigator.of(context).pop(type);
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
