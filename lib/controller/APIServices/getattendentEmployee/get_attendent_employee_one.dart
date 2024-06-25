import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_one_model.dart';

class get_attendent_employee_one {
  model(token) async {
    var shift_date = DateTime.now().toString();
    var formate = shift_date;
    try {
      String url = '${connect_api().domain}/GetTimeStampsoneday';
      var response = await Dio().post(url,data: {"shift_date":"$formate"},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_attendent_employee_one_model json =
            get_attendent_employee_one_model.fromJson(response.data);
        log('GetTimeStampsoneday: ${response.statusCode}');
        return json.data;
      } else {
        log('GetTimeStampsoneday: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('get_attendent_employee_one_shift: ${e}');
    }
  }
}
