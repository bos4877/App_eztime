class refreshToken_Model {
  String? token;
  String? refreshToken;

  refreshToken_Model({this.token, this.refreshToken});

  refreshToken_Model.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
