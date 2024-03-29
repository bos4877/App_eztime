import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';
class card_cpn extends StatelessWidget {
  final VoidCallback press;
  final String title;
  final IconData icon;
  const card_cpn(
      {super.key,
      required this.press,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: IconButton(
          onPressed: press,
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(icon,color:Theme.of(context).primaryColor,size: 18,),
                  SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyles.setting_Style,
                  ).tr(),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}