import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/gettimeattendent/get_attendent_employee_one_model.dart';

class get_attendent_employee_one {
  model(token) async {
    try {
      String url = '${connect_api().domain}/get_attendent_employee_one_shift';
      var response = await Dio().post(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_attendent_employee_one_model json =
            get_attendent_employee_one_model.fromJson(response.data);
        log('get_attendent_employee_one_shift: ${response.statusCode}');
        return json.attendanceData;
      } else {
        log('get_attendent_employee_one_shift: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('get_attendent_employee_one_shift: ${e}');
    }
  }
}
