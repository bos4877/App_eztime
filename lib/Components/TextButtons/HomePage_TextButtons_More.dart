import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';

class TextButtons_More extends StatelessWidget {
  String title;
  Widget page;
  String imagePath;
  TextButtons_More(
      {super.key,
      required this.title,
      required this.page,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => page,
      )),
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
    );
  }
}
 