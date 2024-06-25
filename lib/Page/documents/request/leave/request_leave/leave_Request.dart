import 'dart:developer';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_quota_model/get_quota_leave_model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/PushLeave/PushLeavService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class leave_request_page extends StatefulWidget {
  const leave_request_page({super.key});
  @override
  State<leave_request_page> createState() => _leave_request_pageState();
}

class _leave_request_pageState extends State<leave_request_page> {
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  String? selectedLeaveType;
  TimeOfDay? timeOfDay__startdate;
  TimeOfDay? timeOfDay_enddate;
  List<Data> _quotaleave = [];
  List<DateTime?> _dates = [];
  bool loading = false;
  XFile? pickedImage;
  String? imagePath;
  String? imagePathname;
  String? selectedValue;
  int _quotaleaveCount = 0;
  var token;
  var _Starttime;
  var _Endtime;
  var _Startdate;
  var _Enddate;
  _onRefresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 800));
    await showImage();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shareprefs();
  }

  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    await _getquotaLeave();
  }

  Future _getquotaLeave() async {
    setState(() {
      loading = true;
    });
    try {
      String url = '${connect_api().domain}/getquotaleaveM';
      var response = await Dio().post(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        quota_leave_model json = quota_leave_model.fromJson(response.data);
        setState(() {
          _quotaleave = json.data!;
          _quotaleaveCount = _quotaleave.length - 1;
          loading = false;
        });
      }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      var message = data.split(':').last.split('}').first;
      log(message);
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  showImage() {
    // ที่อยู่ของรูปภาพ

    String image = '${pickedImage!.path}';
    log('message: images ${image}');
    // ตรวจสอบว่ารูปภาพมีหรือไม่
    File imageFile = File(image);
    if (!imageFile.existsSync()) {
      setState(() {
        log('showImage: ${imageFile}');
      });
    }
    // แสดงรูปภาพ
    return Image.file(imageFile);
  }

  images_parse(XFile picked) {
    setState(() {
      loading = true;
    });
    imagePath = picked.path;
    imagePathname = picked.name;
    if (imagePath == null ||
        imagePath!.isEmpty ||
        imagePathname == null ||
        imagePathname!.isEmpty) {
      setState(() {
        imagePath = '';
        imagePathname = '';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Leaverequestlist.title').tr(),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.35,
                vertical: MediaQuery.of(context).size.height * 0.04),
            child: Buttons(
                title: 'buttons.Save'.tr(),
                press: () async {
                  if (imagePathname == null || imagePathname!.isEmpty) {
                    var service = PushLeave_Service();
                    log('imagePathnameSaveSelect: ${selectedValue}');
                    if (selectedValue == null) {
                      Dialog_Error_responseStatus.showCustomDialog(
                          context, 'เลือกหัวข้อการลา');
                    } else {
                      var response = await service
                          .model(
                        token,
                        selectedValue,
                        _Startdate,
                        _Enddate,
                        '',
                        '',
                        leaveDescription.text,
                      )
                          .then(
                        (value) {
                          log('responseStatus: ${value}');
                          if (value == 200) {
                            success_dialog(
                              detail: 'alertdialog_lg.save_Success',
                            ).show(context);
                          } else {
                            Dialog_false.showCustomDialog(context);
                          }
                        },
                      );
                    }
                  } else {
                    var service = PushLeave_Service();
                    log('selectedValue: ${selectedValue}');
                    if (selectedValue == null) {
                      Dialog_Error_responseStatus.showCustomDialog(
                          context, 'เลือกหัวข้อการลา');
                    } else {
                      log('imagePath: ${imagePath}');
                      log('imagePath: ${imagePathname}');
                      var response = await service
                          .model(token, selectedValue, _Startdate, _Enddate,
                              imagePath!, imagePathname!, leaveDescription.text)
                          .then(
                        (value) {
                          log('responseStatus2: ${value}');
                          if (value == 200) {
                            success_dialog(
                              detail: 'alertdialog_lg.save_Success',
                            ).show(context);
                          } else {
                            Dialog_false.showCustomDialog(context);
                          }
                        },
                      );
                    }
                  }
                }),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Request_leave.select'.tr(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 150, // กำหนดความสูงให้ Container
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _quotaleave.map((leavetype) {
                          return _buildLeaveBalanceCard(
                            leavetype.leaveType!,
                            leavetype.quotaLeave!,
                            leavetype.value!,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เลือกวันที่เเละเวลา',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                                'From', '${_datecontrollorStart.text}',
                                () async {
                              await _startdate();
                              timeOfDay__startdate = await _Starttime;
                              setState(() {
                                print(timeOfDay__startdate);
                                if (timeOfDay__startdate == null) {
                                  Dialog_date_alert().showCustomDialog(context);
                                } else {
                                  _datecontrollorStart.text =
                                      '${_Startdate} ${timeOfDay__startdate!.format(context)}';
                                }
                              });
                            }, _datecontrollorStart),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildDatePicker(
                                'To', '${_datecontrollorEnd.text}', () async {
                              await enddate();
                              timeOfDay_enddate = await _Endtime;
                              setState(() {
                                print(timeOfDay_enddate);
                                if (timeOfDay_enddate == null) {
                                  Dialog_date_alert().showCustomDialog(context);
                                } else {
                                  _datecontrollorEnd.text =
                                      '${_Enddate} ${timeOfDay_enddate?.format(context)}';
                                }
                              });
                            }, _datecontrollorEnd),
                          ),
                        ],
                      ),
                      _buildLeaveApplicationForm(),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: _selectImage(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        loading ? LoadingComponent() : SizedBox()
      ],
    );
  }

  Widget _buildStatusCircle(String label, String count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(count, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaveBalanceCard(
      String label, String count, String leave_value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = leave_value;
          log('selectedValue: ${selectedValue}');
          selectedLeaveType = label == selectedLeaveType ? null : label;
        });
      },
      child: Container(
        width: 130, // กำหนดความกว้างให้ Container
        height: 120,
        margin: EdgeInsets.only(right: 8), // เพิ่ม margin ระหว่างการ์ดแต่ละใบ
        child: Card(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(color: Colors.white),
                    ),
                    Checkbox(
                      checkColor: Colors.black,
                      fillColor: MaterialStatePropertyAll(Colors.white),
                      value: selectedLeaveType == label,
                      onChanged: (value) {
                        setState(() {
                          loading = true;
                          selectedLeaveType = value! ? label : null;
                          loading = false;
                          log('selectedValue: ${selectedValue}');
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  '$label',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      ),
    );
  }

  Widget _selectImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Request_leave.AddImage').tr(),
        SizedBox(
          height: 10,
        ),
        pickedImage == null
            ? Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('เลือกรูปภาพ',
                                style: TextStyle(fontSize: 16)),
                            content: Container(
                              width: 80,
                              height: 100,
                              child: Column(
                                children: [
                                  TextButton.icon(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await camera().then(
                                          (value) {
                                            if (value == null) {
                                              Snack_Bar(
                                                  snackBarColor: Colors.red,
                                                  snackBarIcon: Icon(Icons
                                                      .warning_amber_outlined),
                                                  snackBarText: 'ไม่พบรูปภาพ');
                                            } else {
                                              pickedImage = value;
                                              if (pickedImage!
                                                      .name.isNotEmpty ||
                                                  pickedImage!
                                                      .path.isNotEmpty) {
                                                images_parse(pickedImage!);
                                              }

                                              _onRefresh();
                                              log('fill1: ${value}');
                                              log('imagePathname: ${pickedImage}');
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.camera_alt),
                                      label: Text(
                                        'กล้อง',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      )),
                                  TextButton.icon(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        await gallery().then(
                                          (value) {
                                            if (value == null) {
                                            } else {
                                              pickedImage = value;
                                              if (pickedImage!
                                                      .name.isNotEmpty ||
                                                  pickedImage!
                                                      .path.isNotEmpty) {
                                                images_parse(pickedImage!);
                                              }
                                              _onRefresh();
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.photo),
                                      label: Text(
                                        'คลังภาพ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ))
                                ],
                              ),
                            ));
                      },
                    );
                  },
                  icon: Icon(Icons.add_photo_alternate_outlined),
                  label: Text('Request_leave.AddImage').tr(),
                ),
              )
            : Center(
                child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    width: double.infinity,
                    height: 250,
                    child: showImage()),
              ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _buildLeaveApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text('Detail'),
        SizedBox(
          height: 10,
        ),
        Material(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: leaveDescription,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                )),
            maxLines: 4,
          ),
          // รับข้อความหลายบรรทัด
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, String date, VoidCallback pres,
      TextEditingController contro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        TextField(
          controller: contro,
          onTap: pres,
          readOnly: true,
          decoration: InputDecoration(
            hintText: date.isEmpty ? 'เลือกวันที่' : date,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Future _startdate() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.single,
        dayTextStyle: TextStyle(),
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        selectedDayHighlightColor: Theme.of(context).primaryColor,
        closeDialogOnOkTapped: true,
        centerAlignModePicker: true,
        firstDate: DateTime.now(),
      ),
      dialogBackgroundColor: Colors.white,
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    ).then(
      (result) {
        if (result != null && result.isNotEmpty) {
          log(result.toString());
          _Starttime = showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                DateTime.parse('2023-08-23 08:00:00.000')),
          );
          var _date = result.toString();
          var formatdate =
              _date.split('[').last.split(']').first.split(' ').first;
          _Startdate = '$formatdate';
        } else {
          _Startdate = '';
          _Starttime = showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                DateTime.parse('2023-08-23 08:00:00.000')),
          );
          var date = DateTime.now().toString();
          var formatdate =
              date.split('[').last.split(']').first.split(' ').first;
          _Startdate = '$formatdate';
        }
      },
    );
  }

  Future enddate() async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 0,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle:
            TextStyle(color: Colors.grey.shade600, fontSize: 14),
        calendarType: CalendarDatePicker2Type.single,
        dayTextStyle: TextStyle(),
        selectedDayTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        selectedDayHighlightColor: Theme.of(context).primaryColor,
        closeDialogOnOkTapped: true,
        centerAlignModePicker: true,
        firstDate: DateTime.now(),
        // okButton:
      ),
      dialogBackgroundColor: Colors.white,
      dialogSize: Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    ).then((result) {
      print(result);
      if (result != null && result.isNotEmpty) {
        _Endtime = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var _date = result.toString();
        var formatdate =
            _date.split('[').last.split(']').first.split(' ').first;
        _Enddate = '${formatdate}';
      } else {
        _Enddate = '';
        _Endtime = showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(DateTime.parse('2023-08-23 17:30:00.000')),
        );
        var date = DateTime.now().toString();
        var formatdate = date.split('[').last.split(']').first.split(' ').first;
        _Enddate = '$formatdate';
      }
    });
  }
}
