import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';

class get_doc_Ot_list_one_Service {
  model(token)async{
    // log(token);
    String url = '${connect_api().domain}/get_doc_ot_doc_details';
    var response = await Dio().get(url,options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      // log(response.data.toString());
      get_doc_Ot_list_one_model member = get_doc_Ot_list_one_model.fromJson(response.data);
      return member.data;
    } else {
      return response.statusCode;
    }
  }
}