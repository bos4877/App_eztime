import 'package:flutter/material.dart';

class intro_page_one extends StatelessWidget {
  const intro_page_one({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Container(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ยินดีต้อนรับ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.blue.shade700,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                          ),
                        ])),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'พบกับการลงเวลาเข้า-ออกงาน \nแนวทางใหม่ด้วยแอปพลิเคชัน',
                  style: TextStyle(color: Colors.white,fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.network(
                  'https://byte-hr.com/_next/image?url=%2Fhr%2Fimage-banner-left.png&w=1920&q=100',
                  scale: 3.5,
                ),
                SizedBox(height: 20,),
                Text(
                    'การบริหารเวลาเป็นแนวทางที่สำคัญในการจัดการชีวิตทำงานและส่วนตัว เพื่อที่จะทำให้'
                    'กระบวนการนี้เป็นไปได้สะดวกยิ่งขึ้นและมีประสิทธิภาพมากขึ้น เทคโนโลยีมีบทบาทสำคัญ'
                    'แอปพลิเคชันลงเวลา เข้า-ออก งานเป็นหนึ่งในเครื่องมือที่ช่วยในกระบวนการนี้อย่างมี'
                    'ประสิทธิภาพ ทำให้การบริหารเวลาเป็นเรื่องง่ายและเสถียรมากขึ้น',style: TextStyle(color: Colors.white,fontSize: 14),)
              ],
            ),
          )),
    );
  }
}
