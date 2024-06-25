import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class approve_addtime_service {
   Future approve_addtime(add_time_id, status,token) async {
    try {
      String url = '${connect_api().domain}/approve_Addtime';
      var response = await Dio().post(url,
          data: {"doc_id": "$add_time_id", "status": '$status'},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        return 200;
      } else {
        return response.statusCode;
      }
    } on DioError catch (e) {
      var responseData = e.response!.data;
      return responseData;    
  }
  }
}