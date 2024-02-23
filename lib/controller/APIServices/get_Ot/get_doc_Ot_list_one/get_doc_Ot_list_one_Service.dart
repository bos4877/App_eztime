import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';

class get_doc_Ot_list_one_Service {
  model(token)async{
    String url = '${connect_api().domain}/get_doc_Ot_list_one';
    var response = await Dio().get(url,options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      get_doc_Ot_list_one_model member = get_doc_Ot_list_one_model.fromJson(response.data);
      List<DocList>? docList =member.docList; 
      return docList;
    } else {
      return response.statusCode;
    }
  }
}