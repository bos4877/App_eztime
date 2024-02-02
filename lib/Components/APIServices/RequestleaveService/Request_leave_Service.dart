import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/Request_leave/Request_leave_Model.dart';

class Request_leave_Service {
  Future model(var token) async {
    try {
          String url = '${connect_api().domain}/get_leave';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Request_leave_Model json = Request_leave_Model.fromJson(response.data);
          List<Leave> leaves = json.leave!;
          List<Leave> individualLeaves = leaves.map((leave) => leave).toList();
          return individualLeaves;
        } else {
          return null;
        }
    } catch (e) {
      return null;
    }

  }
}
