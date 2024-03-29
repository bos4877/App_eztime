import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_appreove_Ot_Model/get_appreove_Ot_Model.dart';

class get_appreove_Ot_Service {
  model(token) async {
    String url = '${connect_api().domain}/get_ot_list_m';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      get_appreove_Ot_Model model = get_appreove_Ot_Model.fromJson(response.data);
      return model.docList;
    } else {
      return response.statusCode;
    }
  }
}
