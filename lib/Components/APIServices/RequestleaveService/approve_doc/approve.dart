import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Approve_Service {
  model(String id, String status, String token) async {
    String url = '${connect_api().domain}/approve_doc';
    var response = await Dio().post(
      url,
      data: {"doc_l_id": id, "status": status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
