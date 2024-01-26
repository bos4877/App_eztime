import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class PushLeave_Service {
  Future model(var token, var leaveType, String startDate, String startTime,
      String endDate, String endTime, var leaveDescription ,var images) async {
    try {
      String url = '${connect_api().domain}/add_doc_leave';
      var response = await Dio().post(url,
          data: {
            "leaveType": leaveType,
            "startDate": startDate,
            "startTime": startTime,
            "endDate": endDate,
            "endTime": endTime,
            "leaveDescription": leaveDescription,
            "file":images
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        log('PushLeave: ${response.statusCode}');
        log('success');
        return response.statusCode;
      } else {
        log('PushLeaveError: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      log('PushLeavecatchError: ${e}');
      return null;
    }
  }
}
