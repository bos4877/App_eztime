import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_One/get_DocOne_Model/get_DocOne_Model.dart';

class get_DocOne_Service {
  model(var token) async {
    String url = '${connect_api().domain}/get_doc_list_one';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          get_DocOne_Model json = get_DocOne_Model.fromJson(response.data);
          log('get_DocOne_Service: ${response.statusCode}');
          return json.docList;
        } else {
          return null;
        }
  }
}
