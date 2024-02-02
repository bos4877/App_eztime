import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_DocOne_Model/get_DocOne_Model.dart';

class get_DocOne_Service {
  model(var token) async {
    try {
          String url = '${connect_api().domain}/get_doc_list_one';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          get_doc_leavelist_one json = get_doc_leavelist_one.fromJson(response.data);
          log('get_DocOne_Service: ${response.statusCode}');
          return json.docList;
        } else {
          return null;
        }
    } catch (e) {
      log(e.toString());
    }

  }
}
