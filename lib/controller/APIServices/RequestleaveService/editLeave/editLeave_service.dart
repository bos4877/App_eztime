import 'dart:convert';
import 'dart:developer';

import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class edite_leave_service {
  Future model(var token, var id, String type, String startDate, String endDate,
      String imagePath, String imagePathname, String desc) async {
    // log('token: ${token}');
    //  log('id: ${id}');
    //   log('type: ${type}');
    //    log('startDate: ${startDate}');
    //     log('endDate: ${endDate}' );
    //      log('imagePath: ${imagePath}');
    //       log('imagePathname: ${imagePathname}');
    //        log('desc: ${desc}');
    String url = '${connect_api().domain}/edit_Doc_Leave_details_user';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    if (imagePath == null || imagePath.isEmpty) {
      request.fields['doc_id'] = id;
      request.fields['leave_type'] = type;
      request.fields['start_date'] = startDate;
      request.fields['end_date'] = endDate;
      request.fields['description'] = desc;
      // request.fields['file'] = '';
      request.headers['Authorization'] = 'Bearer $token';
    } else {
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imagePath,
        filename: imagePathname,
      );
      request.files.add(multipartFile);
      request.fields['doc_id'] = id;
      request.fields['leave_type'] = type;
      request.fields['start_date'] = startDate;
      request.fields['end_date'] = endDate;
      request.fields['description'] = desc;
      request.headers['Authorization'] = 'Bearer $token';
    }

    var streamedResponse = await request.send();
    try {
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        log('edite: ${response.statusCode}');
        log('success');
        return response.statusCode;
      } else {
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse['message'];
        debugPrint('errorMessage: ${errorMessage}');
        return response.body;
      }
    } catch (e) {
      log('editecatchError: ${e}');
      return null;
    }
  }
}
