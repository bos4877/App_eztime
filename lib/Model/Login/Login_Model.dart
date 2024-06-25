class loginModel {
  int? status;
  String? message;
  String? token;
  String? refreshToken;
  String? role;

  loginModel(
      {this.status, this.message, this.token, this.refreshToken, this.role});

  loginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    data['role'] = this.role;
    return data;
  }
}
