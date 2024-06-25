import 'dart:async';

import 'package:eztime_app/Components/DiaLog/load/loaddialog.dart';
import 'package:flutter/material.dart';

class LoadingProgess extends StatelessWidget {
  // final List data;
  final double receive_progess; //รับค่าเวลา เชื่อมต่อ api
  // final StreamController<double> Controller;
  LoadingProgess({
    super.key,
    //  required this.data,
    required this.receive_progess,
    //  required this.Controller
  });

  double _progress = 0.0;
  StreamController<double> _progressController = StreamController<double>();

  _startLoading() {
    _progress = receive_progess;
    _progressController.stream.listen((progress) {
      _progress = progress;
    });
    loadData(_progressController);
  }

  Future<void> loadData(StreamController<double> controller) async {
    // จำลองการโหลดข้อมูลโดยไม่รู้เวลาที่แน่นอน
    double progress = 0.0;
    while (progress < 1.0) {
      await Future.delayed(Duration(microseconds: 1200)); // จำลองการหน่วงเวลา
      progress += 0.01; // เพิ่มความคืบหน้าทีละ 1%
      controller.add(progress); // ส่งค่าความคืบหน้าที่อัปเดต
    }
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          icon: _startLoading(),
          elevation: 5,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.blue,
                        strokeWidth: 5.0,
                      ),
                    ),
                    LoadingController(), // LoadingController อยู่ใน CircularProgressIndicator
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _progress < 1.0
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                // value: _progress,
                                color: Colors.blue,
                                backgroundColor: Colors.grey.shade200,
                                strokeWidth: 2.0,
                              ),
                            )
                          : Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ตรวจสอบตำแหน่ง',
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${(_progress * 100).round()}%',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
