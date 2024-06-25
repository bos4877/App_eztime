import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_location/get_location_employee.dart';

class get_location_service {
  maodel(token)async{
    try {
          String url = '${connect_api().domain}/GetLocation_Employee';
    var response = await Dio().get(url,
    options: Options(headers: {'Authorization': 'Bearer $token'})
    );
    if (response.statusCode == 200) {
      get_location_model json = get_location_model.fromJson(response.data);
      log('getlocation: ${response.data}');
      return json.data;
    } else {
      return response.statusCode;
    }
    } on DioError catch (e) {
      var data = e.response!.data.toString();
      return data;
    }

  }
}