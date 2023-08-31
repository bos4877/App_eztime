import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:dio/dio.dart';
import 'package:eztime_app/Components/Buttons/Button.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart%20';


class salary_calculation extends StatefulWidget {
  const salary_calculation({super.key});

  @override
  State<salary_calculation> createState() => _salary_calculationState();
}

class _salary_calculationState extends State<salary_calculation> {
  
  final PathProviderAndroid provider = PathProviderAndroid();
  int? _selectedMonth;
  List<String> _months = DateFormat.MMMM().dateSymbols.MONTHS.toList();
  int _selectedYear = DateTime.now().year;
   Future<String?>? _appDocumentsDirectory;
  var mounText;
    var   url = 'https://www.orimi.com/pdf-test.pdf';
  var filename = 'pdf-test.pdf';
  
  Future download(String url, String filename) async {
    ///storage/emulated/0/Download/
  var directory =  provider.getApplicationDocumentsPath();
    var savePath = '$directory/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration(days: DateTime.now().day),
        ),
      );
      if (response.statusCode == 200) {
        // ตอบกลับเรียบร้อย
        var file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        setState(() {});
      } else {
        // จัดการกับการตอบกลับไม่สำเร็จ
        print('การตอบกลับไม่สำเร็จ: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Catch: ${e}');
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + '%');
    }
  }
  @override
  void initState() {
    _selectedMonth = DateTime.now().month;
    mounText = _months[_selectedMonth! - 1];
    
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสรุปเงินเดือน'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('เลือกเดือน',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          _monthsDropDown()
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'เลือกปี',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            _YearDropDown(),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        child: Material(
                          elevation: 3,
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'เดือน $mounText  ปี ${_selectedYear}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text('เงินเดือน :',style: TextStyles.setting_Style,),
                                Text('เบี้ยขยัน :',style: TextStyles.setting_Style,),
                                Text('ขาดงาน :',style: TextStyles.setting_Style,),
                                Text('ประกันสังคม :',style: TextStyles.setting_Style,),
                                Text('เงินเดือนที่ได้รับ :',style: TextStyles.setting_Style,),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await Permission.storage.request();
                                        PermissionStatus _Statust =
                                            await Permission.storage.status;
                                        if (_Statust.isDenied) {
                                          AwesomeDialog(
                                              context: context,
                                              animType: AnimType.scale,
                                              dialogType: DialogType.warning,
                                              title: 'อนุญาตการเข้าถึง',
                                              titleTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              desc:
                                                  'กรุณาอนุญาตเข้าถึงพื้นที่เก็บข้อมูล',
                                              btnOkText: 'เปิดตั้งค่า',
                                              btnOkOnPress: () {
                                                openAppSettings();
                                              },
                                              btnCancelOnPress: () {
                                                Navigator.of(context).canPop();
                                              })
                                            ..show();
                                        } else {
                                         download(url, filename);
                                        }
                                      },
                                      child: Text('สลิปเงินเดือน',style: TextStyles.setting_Style,)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   child: PDFView(
                      //     filePath: pdfUrl,
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _monthsDropDown() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(8),
      underline: Container(
        // Customize the underline
        height: 1,
        color: Colors.blue,
      ),
      elevation: 5,
      style: TextStyle(fontSize: 13, color: Colors.black),
      value: _selectedMonth,
      onChanged: (newValue) {
        setState(() {
          _selectedMonth = newValue!;
          mounText = _months[newValue - 1];
          print(mounText);
          print('_selectedMonth : ${_selectedMonth}');
        });
      },
      items: List<DropdownMenuItem<int>>.generate(
        12,
        (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Text(_months[index]),
          );
        },
      ),
    );
  }

  Widget _YearDropDown() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(8),
      elevation: 5,
      underline: Container(
        // Customize the underline
        height: 1,
        color: Colors.blue,
      ),
      style: TextStyle(fontSize: 13, color: Colors.black),
      value: _selectedYear,
      onChanged: (newValue) {
        setState(() {
          _selectedYear = newValue!;
          print('_selectedYear : ${_selectedYear}');
        });
      },
      items: List<DropdownMenuItem<int>>.generate(
        10,
        (index) {
          int year = DateTime.now().year - 5 + index;
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString()),
          );
        },
      ),
    );
  }
}
