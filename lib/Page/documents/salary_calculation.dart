// ignore_for_file: unused_import// import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';, unused_import, unused_field

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Dialog/Buttons/Button.dart';
import 'package:eztime_app/Components/Dialog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:eztime_app/Test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart%20';

class salary_calculation extends StatefulWidget {
  const salary_calculation({super.key});

  @override
  State<salary_calculation> createState() => _salary_calculationState();
}

class _salary_calculationState extends State<salary_calculation> {
  final PathProviderAndroid provider = PathProviderAndroid();
  bool loading = false;
  bool open = false;
  int? _selectedMonth;
  List<String> _months = DateFormat.MMMM().dateSymbols.MONTHS.toList();
  int _selectedYear = DateTime.now().year;
  Future<String?>? _appDocumentsDirectory;
  var mounText;
  var filename = 'pdf-test.pdf';
  var url = 'https://www.orimi.com/pdf-test.pdf';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    // log('messagedirectory: ${directory.path}');
    return directory.path;
  }

  Future<void> _downloadExcel() async {
    await Permission.storage.request();
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      Dialog_allow_access dialogInstance = Dialog_allow_access(
        desc: 'salary_calculation.noti',
      );
      dialogInstance.showCustomDialog(context);
      // await Permission.storage.request();
    } else {
      setState(() {
        loading = true;
      });
      final savePath = await _getFilePath();
      String? taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savePath,
        fileName: 'testsexample.xls',
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: true,
      );
      await Future.delayed(Duration(milliseconds: 800));
      setState(() {
        open = true;
        loading = false;
      });
    }
  }

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    // if no file is picked
    if (result == null) return;
    // we get the file from result object
    final file = result.files.first;
    _openFile(file);
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  onRefresh() async {
    setState(() {
      loading = true;
    });
    _getFilePath();
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _selectedMonth = DateTime.now().month;
    mounText = _months[_selectedMonth! - 1];
    // TODO: implement initState
    super.initState();
    _getFilePath();
  }

  _onRefresh() {}

  @override
  Widget build(BuildContext context) {
    url;
    filename;
    return Scaffold(
      appBar: AppBar(
        title: Text('salary_calculation.title').tr(),
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: Center(
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
                            Text('salary_calculation.SelectMount',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))
                                .tr(),
                            _monthsDropDown()
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'salary_calculation.SelectYear',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ).tr(),
                              _YearDropDown(),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'salary_calculation.Mount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).tr(),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${mounText}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).tr(),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'salary_calculation.Year',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).tr(),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${_selectedYear}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).tr(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'salary_calculation.Salary',
                          style: TextStyles.setting_Style,
                        ).tr(),
                        Text(
                          'salary_calculation.Hardship Allowance',
                          style: TextStyles.setting_Style,
                        ).tr(),
                        Text(
                          'salary_calculation.Absenteeism',
                          style: TextStyles.setting_Style,
                        ).tr(),
                        Text(
                          'salary_calculation.Social_Security',
                          style: TextStyles.setting_Style,
                        ).tr(),
                        Text(
                          'salary_calculation.Received_Salary',
                          style: TextStyles.setting_Style,
                        ).tr(),
                        Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                await Permission.storage.request();
                                PermissionStatus _Statust =
                                    await Permission.storage.status;
                                if (_Statust.isDenied) {
                                  // await Permission.storage.request();
                                  Dialog_allow_access dialogInstance =
                                      Dialog_allow_access(
                                    desc: 'salary_calculation.noti',
                                  );
                                  dialogInstance.showCustomDialog(context);
                                } else {
                                  if (open) {
                                    _pickFile();
                                  } else {
                                    _downloadExcel();
                                  }
                                }
                              },
                              child: open ? Text('salary_calculation.open').tr(): Text(
                                'salary_calculation.Salary slip',
                                style: TextStyles.setting_Style,
                              ).tr()),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ))
            ],
          ),
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
        color: Theme.of(context).primaryColor,
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
        color: Theme.of(context).primaryColor,
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
