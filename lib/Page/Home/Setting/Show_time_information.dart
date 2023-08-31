import 'package:flutter/material.dart';
class Information_login extends StatefulWidget {
  const Information_login({super.key});

  @override
  State<Information_login> createState() => _Information_loginState();
}

class _Information_loginState extends State<Information_login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ข้อมูลการเข้า-ออกงาน')),
    );
  }
}