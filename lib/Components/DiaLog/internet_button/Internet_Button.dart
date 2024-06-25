import 'package:flutter/material.dart';

class Internet_Buttons extends StatelessWidget {
  // final VoidCallback onPressBtcon;
  final VoidCallback onPressBtsetting;
  final VoidCallback onPressBtclose;
  const Internet_Buttons(
      {super.key,
      required this.onPressBtsetting,
      required this.onPressBtclose});

  @override
  Widget build(BuildContext context) {
    var sizehie = MediaQuery.of(context).size.height;
    var sizeWid = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: onPressBtsetting,
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
                fixedSize: MaterialStatePropertyAll(Size(sizeWid * 0.4, 40)),
                elevation: MaterialStatePropertyAll(5)),
            child: Wrap(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 5),
                Text('ตั้งค่า'),
              ],
            )),
        ElevatedButton(
            onPressed:onPressBtclose,
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                fixedSize: MaterialStatePropertyAll(Size(sizeWid * 0.4, 40)),
                elevation: MaterialStatePropertyAll(5)),
            child: Wrap(
              children: [
                Icon(Icons.cancel_presentation_rounded),
                SizedBox(width: 5),
                Text('ปิดแอป'),
              ],
            )),
      ],
    );
  }
}
