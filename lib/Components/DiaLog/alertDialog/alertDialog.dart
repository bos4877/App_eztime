import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_app_settings/open_app_settings.dart';

String internetError = 'alertdialog_lg.internetError';
String save_Success = 'alertdialog_lg.save_Success';
String success = 'alertdialog_lg.success';
String notdata = 'alertdialog_lg.notdata';
String save_false = 'alertdialog_lg.save_false';
String allow_access = 'alertdialog_lg.allow_access';
String restart_app = 'alertdialog_lg.restart_app';
String datealert = 'alertdialog_lg.datealert';
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
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'ปิด',
              style: TextStyle(color: Colors.red),
            ))
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
          ).tr(),
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
        return Dialog_cath();
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
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('ปิด'))
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
          ).tr(),
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
        return Dialog_date_alert();
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
          ).tr(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            OpenAppSettings.openAppSettings();
          },
          child: Text('opensetting', style: TextStyle(color: Colors.red)),
        ),
        SizedBox(
          width: 5,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
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
          ).tr(),
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

  static showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Dialog_internetError();
      },
    );
  }
}

class Dialog_cancel_Success extends StatelessWidget {
  Dialog_cancel_Success();

  _onPop(context) {
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
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
          ).tr(),
        ],
      ),
      icon: _onPop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Dialog_cancel_Success();
      },
    );
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
      content: Text(notdata).tr(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   builder: (context) => Home_Page(),
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
      barrierColor: Colors.grey.shade300,
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
          Text(save_false).tr(),
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
          ).tr(),
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
          Text(worktimefaild).tr(),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.removeRoute(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home_Page(),
                  ));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home_Page(),
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
          ).tr(),
        ],
      ),
      icon: _onPop(context),
    );
  }

  static void showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black26,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
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
          ).tr(),
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

class Dialog_Error_responseStatus extends StatelessWidget {
  final title;
  final VoidCallback press;
  Dialog_Error_responseStatus({required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Center(
          child: Text(
            'Notification.title',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ).tr(),
        ),
        actions: [
          TextButton(
              onPressed: press,
              child: Text(
                'close',
                style: TextStyle(color: Colors.red),
              ))
        ],
        content: RichText(
            text: TextSpan(children: [
          WidgetSpan(
            child: Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 20,
            ),
          ),
          TextSpan(
              text: title, style: TextStyle(fontSize: 16, color: Colors.black))
        ])));
  }

  static void showCustomDialog(BuildContext context, String title) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Dialog_Error_responseStatus(
          press: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home_Page()),
              (Route<dynamic> route) => false,
            );
          },
          title: title,
        );
      },
    );
  }
}
// Example usage:
// CustomDialog.showCustomDialog(context, 'Dialog Title', 'This is the content of the dialog.');
