import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class document_download_page extends StatefulWidget {
  const document_download_page({super.key});

  @override
  State<document_download_page> createState() => _document_download_pageState();
}

class _document_download_pageState extends State<document_download_page> {
  String _url =
      'https://fitsmallbusiness.com/wp-content/uploads/2022/03/FitSmallBusiness-EXCEL-TEST-TEST.xlsx';
  bool loading = false;
  bool open = false;
  String? idfile;
  @override
  void initState() {
    // TODO: implement initState
    _getFilePath();

    super.initState();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    log('messagedirectory: ${directory.path}');
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
        url: _url,
        savedDir: savePath,
        fileName: 'testsexample.xls',
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: true,
      );
      await Future.delayed(Duration(milliseconds: 800));
      setState(() {
        idfile = taskId;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document.title').tr()),
      body: loading
          ? LoadingComponent()
          : RefreshIndicator(
              onRefresh: () => onRefresh(),
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Card(
                          child: ListTile(
                            trailing: open
                                ? Icon(Bootstrap.folder_symlink)
                                : Icon(Icons.download),
                            minLeadingWidth: 4.0,
                            title: Text(
                              'Document.title',
                              style: TextStyle(fontSize: 14),
                            ).tr(),
                            iconColor: Theme.of(context).primaryColor,
                            leading: Icon(Icons.description_outlined),
                            onTap: () {
                              if (open) {
                                _pickFile();
                              } else {
                                _downloadExcel();
                              }
                            },
                          ),
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
