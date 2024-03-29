import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Approve_ot_Service {
  model(String id, String status, String token) async {
    String url = '${connect_api().domain}/approve_ot';
    var response = await Dio().post(
      url,
      data: {"doc_id": id, "status": status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      return 200;
    } else {
      log(response.statusCode.toString());
      return response.statusCode;
    }
  }
}
