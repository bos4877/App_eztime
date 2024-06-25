import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Edit_Profile_Service {
  model(
    var id,
    String Fname,
    String Lname,
    String sex,
    String nationality,
    String birthDay,
    String bankName,
    String bankNo,
    String phone,
    String email,
    String token,
    var flie
  ) async {
    String url = '${connect_api().domain}/edit_employee';
    var response = await Dio().post(url, data: {
      "employee_no":id,
      "first_name": Fname,
      "last_name": Lname,
      "sex":sex,
      "nationality": nationality,
      "status": '',
      "birth_day": birthDay,
      "bank_name": bankName,
      "bank_no": bankNo,
      "phone": phone,
      "email": email,
      "image":flie,
    },
    options: Options(headers: {
     'Authorization': 'Bearer $token'
    })
    );
    if (response.statusCode == 200) {
      log('edit_employee: ${response.statusCode}');
      return response.statusCode;
    } else {
      log('edit_employee: ${response.statusCode}');
      return null;
    }
  }
}
