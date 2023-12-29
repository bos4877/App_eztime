import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Profile/Profile_Model.dart';
import 'package:flutter/foundation.dart';

class get_profile_service {
  Future getprofile(var token) async {
    try {
      String url = '${connect_api().domain}/getOneEmployee';
      var response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        Profile_Model _json = Profile_Model.fromJson(response.data);
        log('responseStatus_get_profile: ${response.statusCode}');
        return _json.employData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
