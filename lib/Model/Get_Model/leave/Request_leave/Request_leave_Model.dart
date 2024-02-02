class Request_leave_Model {
  List<Leave>? leave;

  Request_leave_Model({this.leave});

  Request_leave_Model.fromJson(Map<String, dynamic> json) {
    if (json['leave'] != null) {
      leave = <Leave>[];
      json['leave'].forEach((v) {
        leave!.add(new Leave.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leave != null) {
      data['leave'] = this.leave!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leave {
  int? rowId;
  String? leaveId;
  String? companyId;
  String? leaveType;

  Leave({this.rowId, this.leaveId, this.companyId, this.leaveType});

  Leave.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    leaveId = json['leave_id'];
    companyId = json['company_id'];
    leaveType = json['leave_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['leave_id'] = this.leaveId;
    data['company_id'] = this.companyId;
    data['leave_type'] = this.leaveType;
    return data;
  }
}
