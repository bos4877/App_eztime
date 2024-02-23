import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';

class TextButtons_More extends StatelessWidget {
  String title;
  String imagePath;
  final notificationCount;
  final VoidCallback onPres;
  TextButtons_More(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onPres,
      this.notificationCount,
      });

  @override
  Widget build(BuildContext context) {
    return  notificationCount == 0 || notificationCount == null ? TextButton(
        onPressed: onPres,
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                imagePath,
                scale: 23,
              ),
              SizedBox(
                width: 5,
              ),
              Text(title, style: TextStyles.normal).tr(),
            ],
          ),
        ),
      ):   badges.Badge(
      position: badges.BadgePosition.topEnd(end: 15,top: 7),
       badgeContent:Text(
                notificationCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
      child: TextButton(
        onPressed: onPres,
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                imagePath,
                scale: 23,
              ),
              SizedBox(
                width: 5,
              ),
              Text(title, style: TextStyles.normal).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
 