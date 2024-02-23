import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class approve_ot_service {
  model(String doc_ot_id, token , status) async {
    String url = '${connect_api().domain}/approve_ot';
    var response = await Dio().post(url,
        data: {
          "doc_ot_id":doc_ot_id,
          "status":status
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          return 200;
        } else {
         return response.statusCode is int; 
        }
  }
}
