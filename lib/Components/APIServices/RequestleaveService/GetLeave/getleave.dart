import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_leave/get_leave_Model.dart';

class get_doc_leave_Service {
  model(var token) async {
    try {
      String url = '${connect_api().domain}/get_doc_list';
      var response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_leave_Model json = get_leave_Model.fromJson(response.data);
        return json;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
