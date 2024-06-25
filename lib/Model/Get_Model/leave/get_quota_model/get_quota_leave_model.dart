class quota_leave_model {
  List<Data>? data;

  quota_leave_model({this.data});

  quota_leave_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? quotaLeave;
  String? value;
  String? leaveType;

  Data({this.quotaLeave, this.value, this.leaveType});

  Data.fromJson(Map<String, dynamic> json) {
    quotaLeave = json['quota_leave'];
    value = json['value'];
    leaveType = json['leave_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quota_leave'] = this.quotaLeave;
    data['value'] = this.value;
    data['leave_type'] = this.leaveType;
    return data;
  }
}
