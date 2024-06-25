import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';
class wrap_body_list extends StatelessWidget {
  String title;
  String subtitle;
  final IconData icons;
  wrap_body_list({super.key, required this.title, required this.subtitle,required this.icons});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Icon(icons,size: 20,),
        SizedBox(width: 5,),
        Text(title).tr(),
        SizedBox(
          width: 5,
        ),
        Text(
          subtitle == null || subtitle.isEmpty ? '' :subtitle,
          style: TextStyles.textStylebodyrequest_leave,
        ).tr(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}