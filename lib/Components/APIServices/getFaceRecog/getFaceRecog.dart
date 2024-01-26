import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/getFaceRecog_Model/getFaceRecog_Model.dart';

class getFaceRecog_Service {
  model(token) async {
    String url = '${connect_api().domain}/get_Face_Recognizing';
    var response = await Dio().get(url,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          getFaceRecog_Model data = getFaceRecog_Model.fromJson(response.data);
          log(data.count.toString());
          return data.count!.toInt();
        } else {
          return null;
        }
  }
}
