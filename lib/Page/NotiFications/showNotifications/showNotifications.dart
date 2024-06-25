import 'package:flutter/material.dart';

class show_Notificationdialog extends StatelessWidget {
  const show_Notificationdialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      child: AlertDialog(
        backgroundColor: Colors.red,
      ),
    );
  }
}