import 'package:flutter/material.dart';

class promble_page extends StatefulWidget {
  const promble_page({super.key});

  @override
  State<promble_page> createState() => _promble_pageState();
}

class _promble_pageState extends State<promble_page> {
  List data = [
    'date: 3,adasd:3,asdsdd:6',
    'ข้อมูล2',
    'ข้อมูล3',
    'ข้อมูล4',
    'ข้อมูล5'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลข่าวสาร'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 250,
          child: Material(
            
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.blue)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'หัวข้อข่าวสาร',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.blue,
                      ),
                      Text(
                        'ข้อมูลเกี่ยวกับรายงาน',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(color: Colors.grey, height: 0,endIndent: 8,indent: 8),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          print('Delete Success!!');
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 20,
                        ),
                        alignment: Alignment.center,
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
