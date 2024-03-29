import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/approve_addtime_model.dart';
import 'package:eztime_app/Model/Get_Model/get_addtime_lis/get_approve_addtime_Model/get_request_addtime_Model.dart';


class get_addtime_list_Service {
  model(token)async{
    String url = '${connect_api().domain}/get_addtime_details_list_m';
    var response = await Dio().get(url,options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode ==200) {
      get_addtime_Model json = get_addtime_Model.fromJson(response.data);
      log('get_addtime_list: ${response.statusCode}');
      return json.data;
    } else {
      log('get_addtime_list: ${response.statusCode}');
      return null;
    }
  }
}
class get_approve_addtime_list_Service {
  model(token)async{
    String url = '${connect_api().domain}/get_addtime_list_m';
    var response = await Dio().get(url,options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode ==200) {
      approve_addtime_model json = approve_addtime_model.fromJson(response.data);
      log('approve_addtime: ${response.statusCode}');
      return json.docList;
    } else {
      log('approve_addtime: ${response.statusCode}');
      return null;
    }
  }
}

