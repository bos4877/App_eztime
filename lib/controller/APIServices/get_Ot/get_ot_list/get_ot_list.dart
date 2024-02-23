import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_model/get_doc_Ot_list_model.dart';

class get_OtList_Service {
  model(token) async {
    String url = '${connect_api().domain}/get_ot_list';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      get_doc_Ot_list_model model = get_doc_Ot_list_model.fromJson(response.data);
      return model.docList;
    } else {
      return response.statusCode;
    }
  }
}
