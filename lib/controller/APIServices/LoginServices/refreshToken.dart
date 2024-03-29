import 'package:dio/dio.dart';
import 'package:eztime_app/Model/Connect_Api.dart';
import 'package:eztime_app/Model/ResetToken/ResetToken_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class refreshToken {
  var resetToken;
  var token;
  shareprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    resetToken = prefs.getString('_resetToken');
    token = prefs.getString('_acessToken');
   await model(resetToken, token);
  }

  model(String resetToken, String original_token) async {
    String url = '${connect_api().domain}/refreshTokenenduser';
    var response = await Dio().post(url,
        data: {"refreshToken":resetToken},
        options: Options(headers: {'Authorization': 'Bearer $original_token'}));

    if (response.statusCode == 200) {
      // log('refresh:${response.data}');
      refreshToken_Model model = refreshToken_Model.fromJson(response.data);
      if (model.token!.isNotEmpty) {
        return model.token;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
