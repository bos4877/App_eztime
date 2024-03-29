import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/Home/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';

String internetError = 'การเชื่อมต่อผิดพลาด';
String save_Success = 'บันทึกสำเร็จ';
String success = 'สำเร็จ';
String notdata = 'ไม่พบข้อมูล';
String save_false = 'บันทึกไม่สำเร็จ';
String allow_access = 'อนุญาติการเข้าถึง';
String restart_app = 'เปลี่ยนภาษาต้องรีสตาร์ทแอป';
String datealert = 'กรุณาเลือกวันที่เเละเวลา';
// String catch_err = '';


class Dialog_cath extends StatelessWidget {
  Dialog_cath();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // shadowColor: Colors.red,
      // surfaceTintColor: Colors.amber,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ).tr(),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(); 
        }, child: Text('ปิด',style: TextStyle(color: Colors.red),))
      ],
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            notdata,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      barrierColor: Colors.transparent.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return Dialog_cath(
        );
      },
    );
  }
}

class Dialog_date_alert extends StatelessWidget {
  Dialog_date_alert();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // shadowColor: Colors.red,
      // surfaceTintColor: Colors.amber,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ).tr(),
      ),
      actions: [
        TextButton(onPressed: () {
          Get.back();
        }, child: Text('ปิด'))
      ],
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            datealert,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog_date_alert(
        );
      },
    );
  }
}

class Dialog_allow_access extends StatelessWidget {
  final String desc;
  Dialog_allow_access({required this.desc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // shadowColor: Colors.red,
      // surfaceTintColor: Colors.amber,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text('opensetting', style: TextStyle(color: Colors.red)),
        ),
        SizedBox(
          width: 5,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BottomNavigationBar_Page(),
            )); // Close the dialog
          },
          child: Text('Close', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Dialog_allow_access(
          desc: desc,
        );
      },
    );
  }
}

class Dialog_internetError extends StatelessWidget {
  Dialog_internetError();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            internetError,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // ปิดกล่องโต้ตอบ
          },
          child: Text('Close', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // static  showCustomDialog(BuildContext context) {
  //   showDialog(
  //     barrierDismissible: false,
  //     barrierColor: Colors.white,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog_internetError();
  //     },
  //   );
  // }
}

class Dialog_save_Success extends StatelessWidget {
  Dialog_save_Success();

  _onPop(context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            save_Success,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      icon: _onPop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Dialog_save_Success();
      },
    ).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavigationBar_Page(),
      ));
    });
  }
}

class Dialog_notdata extends StatelessWidget {
  Dialog_notdata();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Notification.title',
      ).tr(),
      content: Text(notdata),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   builder: (context) => BottomNavigationBar_Page(),
            // )); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.grey.shade300
      ,
      context: context,
      builder: (BuildContext context) {
        return Dialog_notdata();
      },
    );
  }
}

class Dialog_false extends StatelessWidget {
  Dialog_false();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Notification.title',
              style: TextStyle(fontSize: 16, color: Colors.red))
          .tr(),
      content: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 20,
          ),
          Text(save_false),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog_false();
      },
    );
  }
}

class Dialog_approveSuccess extends StatelessWidget {
  Dialog_approveSuccess();

  _pop(context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Notification.title',
      ).tr(),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            success,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      icon: _pop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog_approveSuccess();
      },
    );
  }
}

class Dialog_worktimefaild extends StatelessWidget {
  final worktimefaild;
  Dialog_worktimefaild(this.worktimefaild);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.info,
            size: 20,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(worktimefaild),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BottomNavigationBar_Page(),
              ));
            },
            child: Text(
              'close',
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }

  static void showCustomDialog(BuildContext context, String worktimefaild) {
    showDialog(
      barrierColor: Colors.black54,
      context: context,
      builder: (BuildContext context) {
        return Dialog_worktimefaild(worktimefaild);
      },
    );
  }
}

class Dialog_Success extends StatelessWidget {
  Dialog_Success();

  _onPop(context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            save_Success,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      icon: _onPop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Dialog_Success();
      },
    ).then((value) {
     Navigator.pop(context);
    });
  }
}

class selectedLanguage_dialog extends StatelessWidget {
  selectedLanguage_dialog();

  // _onPop(context) {
  //   Timer(Duration(seconds: 2), () {
  //     Navigator.of(context).pop();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Restart.restartApp();
                },
                child: Text('รีสตาร์ท',style: TextStyle(color: Colors.yellow),)),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('กลับ',style: TextStyle(color: Colors.red),)),
          ],
        )
      ],
      title: Center(
        child: Text(
          'Notification.title',
          style: TextStyle(fontSize: 16, color: Colors.yellow),
        ).tr(),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.yellow,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            restart_app,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return selectedLanguage_dialog();
      },
    );
  }
}

// Example usage:
// CustomDialog.showCustomDialog(context, 'Dialog Title', 'This is the content of the dialog.');
