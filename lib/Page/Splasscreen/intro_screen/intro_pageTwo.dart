import 'package:flutter/material.dart';

class intro_page_two extends StatelessWidget {
  const intro_page_two({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  'ทำไมต้องลงเวลา ด้วยแอปพลิเคชัน?',
                  style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 10),
                Text('1. ความสะดวกสบายที่คุณต้องการ',
                  style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
                Text('การใช้แอปพลิเคชันลงเวลาเข้า-ออกงานทำให้คุณสามารถทำกระบวนการนี้ได้อย่างรวดเร็วและไม่ยุ่งยาก '
                'คุณสามารถลงเวลาเข้า-ออกงานได้ทุกที่ทุกเวลา',
                  style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 5,
                        color: Colors.white
                      )
                    ] ),
                    alignment: Alignment.bottomRight,
                    child: Image.network('https://www.jarvizapp.com/wp-content/uploads/'
                    'sites/20/2022/11/%E0%B8%97%E0%B8%B3%E0%B9%84%E0%B8%A1%E0%B8%95%E0%B9%89%E0%B8%'
                    'AD%E0%B8%87%E0%B8%A1%E0%B8%B5%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%A5%E0%B8%87%E0%B9%80%E'
                    '0%B8%A7%E0%B8%A5%E0%B8%B2%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B8%B2%E0%B8%99-690-%C3%97-666-px-1-1.jpg'
                    ,scale: 5,),
                  )
          ],
        ),
      ),
    );
  }
}
