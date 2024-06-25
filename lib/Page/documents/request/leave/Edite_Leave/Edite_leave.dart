// Edit_leave_page
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Camera/ImagePickerComponent.dart';
import 'package:eztime_app/Components/DiaLog/Buttons/Button.dart';
import 'package:eztime_app/Components/DiaLog/SnackBar/Sanckbar.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/alertDialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_pop_dialog.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/successDialog/success_dialog.dart';
import 'package:eztime_app/Components/DiaLog/load/LoadingComponent.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_quota_model/get_quota_leave_model.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/editLeave/editLeave_service.dart';
import 'package:eztime_app/controller/APIServices/RequestleaveService/get_pic_doc/get_pic_doc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_leave_page extends StatefulWidget {
  late String docid;
  late String leavetype;
  late String leaveName;
  late String startdate;
  late String enddate;
  late String detail;
  Edit_leave_page({
    super.key,
    required this.docid,
    required this.leavetype,
    required this.leaveName,
    required this.startdate,
    required this.enddate,
    required this.detail,
  });
  @override
  State<Edit_leave_page> createState() => _Edit_leave_pageState();
}

class _Edit_leave_pageState extends State<Edit_leave_page> {
  TextEditingController _datecontrollorStart = TextEditingController();
  TextEditingController _datecontrollorEnd = TextEditingController();
  TextEditingController leaveDescription = TextEditingController();
  String? nameLeaveType;
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
  String? docId;
  String? image_request;
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
    loading = true;
    _settext();
    shareprefs();
  }

  Future shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('_acessToken');
    //await get_Device_token_service().model(token);
    await _getquotaLeave();
    await _get_images(docId);
    await showImage();
  }

  Future _settext() async {
    setState(() {
      _datecontrollorStart = TextEditingController(text: widget.startdate);
      _datecontrollorEnd = TextEditingController(text: widget.enddate);
      nameLeaveType = widget.leavetype;
      selectedLeaveType = widget.leaveName;
      leaveDescription = TextEditingController(text: widget.detail);
      docId = widget.docid;
      log(docId!);
      loading = false;
    });
  }

  Future _getquotaLeave() async {
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
      var data = e.response?.data.toString();
      var message = data?.split(':').last.split('}').first;
      log('message: ${message}');
      loading = false;
      Dialog_Error_responseStatus.showCustomDialog(context, '${message}');
    }
  }

  _get_images(docid) async {
    setState(() {
      loading = true;
    });
    var get_images = await get_pic_docService().model(token, docid);
    setState(() {
      image_request = get_images;
      loading = false;
    });
  }

  showImage() {
    // ที่อยู่ของรูปภาพ
    if (pickedImage != null || pickedImage?.path != null) {
      String image = '${pickedImage?.path}';
      // ตรวจสอบว่ารูปภาพมีหรือไม่
      File imageFile = File(image);
      if (!imageFile.existsSync()) {}
      setState(() {
        loading = false;
      });
      return Image.file(imageFile);
    } else {
      String image = '${image_request}';
      // ตรวจสอบว่ารูปภาพมีหรือไม่
      File imageFile = File(image);
      if (!imageFile.existsSync()) {}
      // แสดงรูปภาพ
      setState(() {
        loading = false;
      });
      return Image.network(image);
    }
  }

  images_parse(XFile picked) {
    imagePath = picked.path;
    imagePathname = picked.name;
    image_request = '';
    if (imagePath == null ||
        imagePath!.isEmpty ||
        imagePathname == null ||
        imagePathname!.isEmpty) {
      setState(() {
        imagePath = '';
        imagePathname = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('editleave.title').tr(),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.35,
                vertical: MediaQuery.of(context).size.height * 0.04),
            child: Buttons(
                title: 'buttons.Save'.tr(),
                press: () async {
                  if (imagePathname == null || imagePathname!.isEmpty) {
                    var service = edite_leave_service();
                    if (nameLeaveType == null) {
                      false_pop_dialog(
                        detail: 'editleave.choose',
                      ).show(context);
                    } else {
                      var response = await service
                          .model(
                        token,
                        docId,
                        nameLeaveType.toString(),
                        _datecontrollorStart.text,
                        _datecontrollorEnd.text,
                        '',
                        '',
                        leaveDescription.text,
                      )
                          .then(
                        (responseStatus) {
                          if (responseStatus == 200) {
                            Dialog_Success.showCustomDialog(context);
                            Navigator.of(context).pop();
                          } else {
                            var jsonResponse = json.decode(responseStatus);
                            String errorMessage = jsonResponse['message'];
                            false_pop_dialog(
                              detail: '$errorMessage',
                            ).show(context);
                          }
                        },
                      );
                    }
                  } else {
                    if (image_request != null || image_request!.isNotEmpty) {
                      var service = edite_leave_service();
                      if (nameLeaveType == null) {
                        false_pop_dialog(
                          detail: 'editleave.choose',
                        ).show(context);
                      } else {
                        var response = await service
                            .model(
                                token,
                                docId,
                                nameLeaveType.toString(),
                                _datecontrollorStart.text,
                                _datecontrollorEnd.text,
                                imagePath!,
                                imagePathname!,
                                leaveDescription.text)
                            .then(
                          (responseStatus) {
                            if (responseStatus == 200) {
                              success_dialog(
                                detail: '',
                              ).show(context);
                              Navigator.of(context).pop();
                            } else {
                              var jsonResponse = json.decode(responseStatus);
                              String errorMessage = jsonResponse['message'];
                              false_pop_dialog(
                                detail: '$errorMessage',
                              ).show(context);
                            }
                          },
                        );
                      }
                    } else {
                      var service = edite_leave_service();
                      if (docId == null) {
                        false_pop_dialog(
                          detail: 'editleave.choose',
                        ).show(context);
                      } else {
                        imagePath = image_request;
                        imagePathname = image_request?.split('c/').last;
                        nameLeaveType = selectedValue;
                        var response = await service
                            .model(
                                token,
                                docId,
                                nameLeaveType.toString(),
                                _datecontrollorStart.text,
                                _datecontrollorEnd.text,
                                '',
                                '',
                                leaveDescription.text)
                            .then(
                          (responseStatus) {
                            if (responseStatus == 200) {
                              success_dialog(
                                detail: '',
                              ).show(context);
                              Navigator.of(context).pop();
                            } else {
                              var jsonResponse = json.decode(responseStatus);
                              String errorMessage = jsonResponse['message'];
                              false_pop_dialog(
                                detail: '$errorMessage',
                              ).show(context);
                            }
                          },
                        );
                      }
                    }
                  }
                }),
          ),
          body: loading
              ? LoadingComponent()
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Request_leave.select'.tr(),
                        ),
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
                            Text('editleave.datetime',
                                    style: TextStyle(fontSize: 16))
                                .tr(),
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
                                        Dialog_date_alert()
                                            .showCustomDialog(context);
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
                                      'To', '${_datecontrollorEnd.text}',
                                      () async {
                                    await enddate();
                                    timeOfDay_enddate = await _Endtime;
                                    setState(() {
                                      print(timeOfDay_enddate);
                                      if (timeOfDay_enddate == null) {
                                        Dialog_date_alert()
                                            .showCustomDialog(context);
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
          nameLeaveType = selectedValue;
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
    return _addimage();
  }

  Widget _addimage() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text('Request_leave.AddImage').tr(),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('editleave.selectdate',
                                style: TextStyle(fontSize: 16))
                            .tr(),
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
                                              snackBarIcon: Icon(
                                                  Icons.warning_amber_outlined),
                                              snackBarText:
                                                  'editleave.not_images');
                                        } else {
                                          pickedImage = value;
                                          if (pickedImage!.name.isNotEmpty ||
                                              pickedImage!.path.isNotEmpty) {
                                            images_parse(pickedImage!);
                                          }
                                          _onRefresh();
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.camera_alt),
                                  label: Text(
                                    'editleave.camera',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ).tr()),
                              TextButton.icon(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    await gallery().then(
                                      (value) {
                                        if (value == null) {
                                        } else {
                                          pickedImage = value;
                                          if (pickedImage!.name.isNotEmpty ||
                                              pickedImage!.path.isNotEmpty) {
                                            images_parse(pickedImage!);
                                          }
                                          _onRefresh();
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.photo),
                                  label: Text(
                                    'editleave.gallery',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ).tr())
                            ],
                          ),
                        ));
                  },
                );
              },
              icon: Icon(Icons.add_photo_alternate_outlined))
        ],
      ),
      SizedBox(
        height: 10,
      ),
      image_request == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('editleave.selectimages',
                                  style: TextStyle(fontSize: 16))
                              .tr(),
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
                                                snackBarText:
                                                    'editleave.not_images');
                                          } else {
                                            pickedImage = value;
                                            if (pickedImage!.name.isNotEmpty ||
                                                pickedImage!.path.isNotEmpty) {
                                              images_parse(pickedImage!);
                                            }
                                            _onRefresh();
                                          }
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.camera_alt),
                                    label: Text(
                                      'editleave.camera',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ).tr()),
                                TextButton.icon(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await gallery().then(
                                        (value) {
                                          if (value == null) {
                                          } else {
                                            pickedImage = value;
                                            if (pickedImage!.name.isNotEmpty ||
                                                pickedImage!.path.isNotEmpty) {
                                              images_parse(pickedImage!);
                                            }
                                            _onRefresh();
                                          }
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.photo),
                                    label: Text(
                                      'editleave.gallery',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ).tr())
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
          : pickedImage == null
              ? Center(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      width: double.infinity,
                      height: 250,
                      child: image_request == null || image_request!.isEmpty
                          ? showImage()
                          : pickedImage == null
                              ? showImage()
                              : showImage()),
                )
              : Center(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      width: double.infinity,
                      height: 250,
                      child: image_request == null || image_request!.isEmpty
                          ? showImage()
                          : pickedImage == null
                              ? showImage()
                              : showImage()),
                ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 5,
      ),
    ]);
  }

  Widget _buildLeaveApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text('editleave.detail').tr(),
        SizedBox(
          height: 10,
        ),
        Material(
          color: Colors.white,
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
            hintText: date.isEmpty ? 'editleave.selectdate'.tr() : date,
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
