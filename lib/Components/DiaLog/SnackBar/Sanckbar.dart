import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';

class Snack_Bar extends StatelessWidget {
  final Color snackBarColor;
  final String snackBarText;
  final  snackBarIcon;

  const Snack_Bar({
    Key? key,
   required this.snackBarColor,
   required this.snackBarIcon, // กำหนดสีเริ่มต้นเป็นสีฟ้า
   required this.snackBarText// ข้อความเริ่มต้น
  }) : super(key: key);

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(

      content: Row(
        crossAxisAlignment:  CrossAxisAlignment.end,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(snackBarIcon,color: Colors.white,size: 23,),
          SizedBox(width: 5,),
          Text(snackBarText,style: TextStyles.SanckbarStyle,).tr(),
        ],
      ),
      backgroundColor: snackBarColor, // กำหนดสี SnackBar จากค่าที่รับมา
       behavior: SnackBarBehavior.floating,
       duration: Duration(seconds: 2),
       
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: Text('Show Snackbar'),
        color: snackBarColor, // กำหนดสีปุ่มจากค่าที่รับมา
        textColor: Colors.white,
        onPressed: () {
          showSnackBar(context);
        },
      ),
    );
  }
}
