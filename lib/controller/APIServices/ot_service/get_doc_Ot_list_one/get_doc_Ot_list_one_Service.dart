import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/Ot/get_doc_Ot_list_one/get_doc_Ot_list_one_model.dart';
import 'package:flutter/material.dart';

class get_doc_Ot_list_one_Service {
  model(var token, BuildContext context) async {
    try {
      String url = '${connect_api().domain}/get_doc_ot_doc_details';
      var response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_doc_Ot_list_one_model member =
            get_doc_Ot_list_one_model.fromJson(response.data);
        return member.data;
      } else {
        return response.statusCode;
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          false_dialog().show(context);
          break;
        case DioExceptionType.connectionTimeout:
          false_dialog().show(context);
          break;
        case DioExceptionType.badResponse:
        var dioerroe = json.decode(error.message!) ;
        false_dialog(detail: dioerroe,).show(context);
        break;
      }
    }
  }
}
