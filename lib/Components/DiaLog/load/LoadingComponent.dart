import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/load/loaddialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  LoadingComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: AlertDialog(
          elevation: 5,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.blue,
                        strokeWidth: 5.0,
                      ),
                    ),
                    LoadingController(), // LoadingController อยู่ใน CircularProgressIndicator
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'loading.title'.tr(),
                style: TextStyles.loadTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
