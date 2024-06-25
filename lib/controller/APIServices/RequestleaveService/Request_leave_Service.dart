import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/Request_leave/Request_leave_Model.dart';

class Request_leave_Service {
  Future model(var token) async {
    try {
          String url = '${connect_api().domain}/Get_Leave_Dropdown_m';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Request_leave_Model json = Request_leave_Model.fromJson(response.data);
          print('object ${response.data}');
          return json.data;
        } else {
          return null;
        }
    } catch (e) {
      return null;
    }

  }
}
