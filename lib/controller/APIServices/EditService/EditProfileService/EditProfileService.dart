import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';

class Edit_Profile_Service {
  model(
    String Fname,
    String Lname,
    String nationality,
    String status,
    String birthDay,
    String bankName,
    String bankNo,
    String phone,
    String email,
    String token,
    var id,
  ) async {
    String url = '${connect_api().domain}/edit_employee';
    var response = await Dio().post(url, data: {
      "employee_no":id,
      "first_name": Fname,
      "last_name": Lname,
      "nationality": nationality,
      "status": status,
      "birth_day": birthDay,
      "bank_name": bankName,
      "bank_no": bankNo,
      "phone": phone,
      "email": email
    },
    options: Options(headers: {
     'Authorization': 'Bearer $token'
    })
    );
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      return response.statusCode;
    } else {
      return null;
    }
  }
}
