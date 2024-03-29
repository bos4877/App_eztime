import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/Get_Model/leave/Images_doc_Model/Images_doc_Model.dart';

class get_pic_docService {
  model(token, String doc_l_id) async {
    String url = '${connect_api().domain}/get_pic_doc';
    var response = await Dio().post(url,
        data: {"doc_id": doc_l_id},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Images_doc_Model_leavelist json = Images_doc_Model_leavelist.fromJson(response.data);
          String image = json.img!;
          if (image == 'ไม่พบรูปภาพ') {
            return image;
          } else {
            return image;
          }
        } else {
          return null;
        }
  }
}
