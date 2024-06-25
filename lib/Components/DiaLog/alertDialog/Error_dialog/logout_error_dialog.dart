import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/controller/APIServices/logOut/Logout_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class logout_error_dialog extends StatelessWidget {
  logout_error_dialog({super.key});
  void show(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return logout_error_dialog(
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizewid = MediaQuery.of(context).size.width;
    var sizehhei = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: sizehhei * 0.49,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            width: sizewid * 0.6,
            height: sizehhei * 0.15,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black26,
          body: Stack(
            children: [
              AlertDialog(
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.redAccent)),
                      child: Text(
                        'alertdialog_lg.logout',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ).tr(),
                      onPressed: () {
                       logOut_service().model(context);
                      },
                    ),
                  )
                ],
                title: Container(
                  width: sizewid * 0.6,
                  height: sizehhei * 0.3,
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Request_leave.Details',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                          Text(
                            'alertdialog_lg.not_session',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ).tr()
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'alertdialog_lg.save_false',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ).tr(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            bottom: sizehhei * 0.42,
            child: Card(
              elevation: 10,
              shape: CircleBorder(),
              child: Icon(
                Bootstrap.x_circle_fill,
                color: Colors.redAccent,
                size: 80,
              ),
            )),
      ],
    );
  }
}
