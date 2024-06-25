import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';

class TextButtons_More extends StatelessWidget {
  String title;
  String imagePath;
  final notificationCount;
  final VoidCallback onPres;
  TextButtons_More({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPres,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 1,
      minLeadingWidth: 30,
      minVerticalPadding: 10,
      leading: Image.asset(
        imagePath,
        scale: 23,
      ),
      title: Text(title, style: TextStyles.normal).tr(),
      onTap: onPres,
      trailing: notificationCount == 0 || notificationCount == null
          ? CircleAvatar(
            backgroundColor: Colors.transparent,
          )
          : CircleAvatar(
            radius: 15,
            backgroundColor: Colors.red,
            child: Text("${notificationCount.toString()}",style: TextStyle(color: Colors.white,shadows: [
              Shadow( color: Colors.white,blurRadius: 0.2)
            ])),
          ),
    );
  }
}
