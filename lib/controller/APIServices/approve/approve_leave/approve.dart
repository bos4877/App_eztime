import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Approve_Leave_Service {
  model(String id, String status, String token) async {
    try {
          String url = '${connect_api().domain}/approve_Leave';
    var response = await Dio().post(
      url,
      data: {"doc_id": id, "status": status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return 200;
    } else {
      return response.statusCode is int;
    }
    } on DioError catch (e) {
    var responseData = e.response!.data;
      return responseData;
    }

  }
}
