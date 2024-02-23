import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_ot/get_Ot_Model.dart';

class get_Ot_Service {
  model(token) async {
    String url = '${connect_api().domain}/get_ot';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      get_Ot_Model model = get_Ot_Model.fromJson(response.data);
      return model.ot;
    } else {
      return response.statusCode;
    }
  }
}
