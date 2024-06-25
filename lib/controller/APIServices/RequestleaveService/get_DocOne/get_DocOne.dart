import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';
import 'package:flutter/material.dart';

class get_DocOne_Service {
  model(var token) async {
    try {
          String url = '${connect_api().domain}/get_user_leave_list';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          get_leavelist_one_Model json = get_leavelist_one_Model.fromJson(response.data);
          debugPrint('get_DocOne_Service: ${response.statusCode}');
          return json.data;
        } else {
          return null;
        }
    } catch (e) {
      debugPrint('get_DocOne_Service_catch: ${e}');
    }

  }
}
