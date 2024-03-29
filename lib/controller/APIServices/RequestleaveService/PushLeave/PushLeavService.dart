import 'dart:developer';

import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:http/http.dart' as http;

class PushLeave_Service {
  Future model(var token, var id, String startDate, String endDate,
      String imagePath, String imagePathname, String desc) async {
    String url = '${connect_api().domain}/add_leave_doc';

var request = http.MultipartRequest('POST', Uri.parse(url));
if (imagePath == null || imagePath.isEmpty) {
request.fields['leave_id'] = id;
request.fields['start_date'] = startDate;
request.fields['end_date'] = endDate;
request.fields['description'] = desc;
request.fields['file'] = '';
request.headers['Authorization'] = 'Bearer $token';
} else {
  var multipartFile = await http.MultipartFile.fromPath(
  'file',
  imagePath,
  filename: imagePathname,
);
request.files.add(multipartFile);
request.fields['leave_id'] = id;
request.fields['start_date'] = startDate;
request.fields['end_date'] = endDate;
request.fields['description'] = desc;
request.headers['Authorization'] = 'Bearer $token';
}

var streamedResponse = await request.send();
    try {
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        log('PushLeave: ${response.statusCode}');
        log('success');
        return response.statusCode;
      } else {
        log('PushLeaveError: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      log('PushLeavecatchError: ${e}');
      return null;
    }
  }
}
