import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Company/get_company_local.dart';

class get_company_local_Service {
  model(token) async {
    String url = '${connect_api().domain}/get_company_local';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          get_company_local member = get_company_local.fromJson(response.data);
          log('get_company_local: ${response.statusCode}');
          return member.company;
        } else {
          log('get_company_local: ${response.statusCode}');
          return null;
        }
  }
}
