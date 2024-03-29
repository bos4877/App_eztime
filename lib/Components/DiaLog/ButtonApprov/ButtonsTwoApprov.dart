import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ButtonTwoAppprove extends StatelessWidget {
  final VoidCallback onPressBtSucess;
  final VoidCallback onPressBtNotsuc;
  const ButtonTwoAppprove({super.key,required this.onPressBtSucess,required this.onPressBtNotsuc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 30,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: onPressBtSucess,
              icon: Icon(Icons.check_circle_rounded, size: 12),
              label: Text(
                'Apporv_Improve_Uptime.Approve',
                style: TextStyle(fontSize: 9),
              ).tr()),
        ),
        SizedBox(width: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 30,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: onPressBtNotsuc,
              icon: Icon(Icons.close, size: 12),
              label: Text('Apporv_Improve_Uptime.Not Approve',
                style: TextStyle(fontSize: 9),).tr()),
        ),

      ],
    );
  }
}
