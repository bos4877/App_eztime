import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_appreove_leave/get_appreove_leave.dart';

class get_appreove_leave_Service {
  Future model(token) async {
    String url = '${connect_api().domain}/get_doc_leave_list_mobile';
    var response = await Dio().get(url, options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      get_appreove_leave_Model json =
          get_appreove_leave_Model.fromJson(response.data);
      return json.docList;
    } else {
      return null;
    }
  }
}
