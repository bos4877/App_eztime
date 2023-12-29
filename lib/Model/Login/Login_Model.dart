class LoginModel {
  String? message;
  String? token;
  String? refreshToken;

  LoginModel({this.message, this.token, this.refreshToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
