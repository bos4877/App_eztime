import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_addtime_list_model%20.dart';

class get_addtime_list_Service {
  model(token)async{
    String url = '${connect_api().domain}/get_addtime_list';
    var response = await Dio().get(url,options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode ==200) {
      get_addtime_list_model json = get_addtime_list_model.fromJson(response.data);
      return json.docList;
    } else {
      return null;
    }
  }
}

