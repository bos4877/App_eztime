import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_ot/get_Ot_Model.dart';

class get_Ot_Service {
  model() async {
    String url = '${connect_api().domain}/Get_Ot_Dropdown_m';
    var response = await Dio().get(url,
        );
    if (response.statusCode == 200) {
      get_Ot_Model model = get_Ot_Model.fromJson(response.data);
      return model.data;
    } else {
      return response.statusCode;
    }
  }
}
