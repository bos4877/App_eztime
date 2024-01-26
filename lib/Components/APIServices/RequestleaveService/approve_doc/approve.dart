import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Approve_Service {
  model(var id,var status) async {
    String url = '${connect_api().domain}/approve_doc';
    var response = await Dio().post(url, data: {
      "doc_l_id": "${id}",
      "status": '$status'
    });
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
