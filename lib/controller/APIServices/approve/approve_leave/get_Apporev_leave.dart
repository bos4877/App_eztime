import 'package:dio/dio.dart';
import 'package:eztime_app/Components/DiaLog/alertDialog/falseDialog/false_dialog.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/get_appreove_leave/get_appreove_leave.dart';
import 'package:flutter/material.dart';

class get_appreove_leave_Service {
  Future model(token, BuildContext context) async {
    try {
      String url = '${connect_api().domain}/get_doc_leave_list_mobile';
      var response = await Dio().get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        get_appreove_leave_Model json =
            get_appreove_leave_Model.fromJson(response.data);
        return json.docList;
      } else {
        return null;
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          false_dialog(
            detail: 'alertdialog_lg.internetError',
          ).show(context);
          break;
        case DioExceptionType.connectionTimeout:
          false_dialog(
            detail: 'alertdialog_lg.Timeout',
          ).show(context);
          break;
        case DioExceptionType.badResponse:
          var data = error.response!.data.toString();
          var message = data.split(':').last.split('}').first;
          false_dialog(
            detail: '$message',
          ).show(context);
          break;
      }
    }
  }
}
