class loginModel {
  int? status;
  String? message;
  String? token;
  String? refreshToken;

  loginModel({this.status, this.message, this.token, this.refreshToken});

  loginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
