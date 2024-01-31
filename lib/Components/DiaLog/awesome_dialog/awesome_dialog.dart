import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
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
      desc: 'การเชื่อมต่อผิดพลาด',
      btnCancelOnPress: () {},
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

  checkFacedialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'แจ้งเตือน',
      desc: 'ตรวจสอบสำเร็จ',
      autoHide: Duration(seconds: 2),
      // dismissOnTouchOutside: false,
      // onDismissCallback: (type) {
      //   Navigator.of(context).pop(type);
      // },
    )..show();
  }

  checkFacedFaildialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'แจ้งเตือน',
      desc: 'ไม่พบใบหน้า',
      autoHide: Duration(seconds: 2),
      dismissOnTouchOutside: false,
      onDismissCallback: (type) {
        Navigator.of(context).pop(type);
      },
    )..show();
  }

  checkinsuccessdialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'แจ้งเตือน',
      desc: 'เข้างานสำเร็จ',
      autoHide: Duration(seconds: 2),
      dismissOnTouchOutside: false,
      onDismissCallback: (type) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (type) => BottomNavigationBar_Page(),
        ));
      },
    )..show();
  }
    checkinfaildialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'แจ้งเตือน',
      desc: 'เข้างานไม่สำเร็จ',
      autoHide: Duration(seconds: 2),
      dismissOnTouchOutside: false,
      // onDismissCallback: (type) {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (type) => BottomNavigationBar_Page(),
      //   ));
      // },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
