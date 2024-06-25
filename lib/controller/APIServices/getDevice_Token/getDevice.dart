import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/get_device_token_model/get_device_token_model.dart';

class get_Device_token_service {
   model(String token) async {
    log('device: ${token}');
    try {
      String url = '${connect_api().domain}/Get_Device_Token';
      var response = await Dio().get(url, options: Options(headers: {'Authorization': 'Bearer $token'}));
      log(response.requestOptions.toString());
      if (response.statusCode == 200) {
        get_device_token_model json =
            get_device_token_model.fromJson(response.data);
            log('json.data!.deviceToken: ${json.data!.deviceToken}');
        if (json.data!.deviceToken == '') {
          log('json.data!.deviceToken: ${json.data!.deviceToken}');
          return json.data!.deviceToken;
        }else{
          return json.data!.deviceToken;
        }
      }
    } on DioError catch (e) {
      var responseData = e.response?.data.toString();
      return responseData;   
    }
  }
}
