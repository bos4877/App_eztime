class get_DocOne_Model {
  List<DocList>? docList;

  get_DocOne_Model({this.docList});

  get_DocOne_Model.fromJson(Map<String, dynamic> json) {
    if (json['doc_list'] != null) {
      docList = <DocList>[];
      json['doc_list'].forEach((v) {
        docList!.add(new DocList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docList != null) {
      data['doc_list'] = this.docList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocList {
  String? docLId;
  String? leaveId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? employeeNo;
  String? companyId;
  String? description;
  String? createAt;
  Leave? leave;
  String? status;
  List<ApproveBy>? approveBy;
  String? status2;
  String? approveBy2;

  DocList(
      {this.docLId,
      this.leaveId,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.employeeNo,
      this.companyId,
      this.description,
      this.createAt,
      this.leave,
      this.status,
      this.approveBy,
      this.status2,
      this.approveBy2});

  DocList.fromJson(Map<String, dynamic> json) {
    docLId = json['doc_l_id'];
    leaveId = json['leave_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    employeeNo = json['employee_no'];
    companyId = json['company_id'];
    description = json['description'];
    createAt = json['create_at'];
    leave = json['Leave'] != null ? new Leave.fromJson(json['Leave']) : null;
    status = json['status'];
    if (json['approve_by'] != null) {
      approveBy = <ApproveBy>[];
      json['approve_by'].forEach((v) {
        approveBy!.add(new ApproveBy.fromJson(v));
      });
    }
    status2 = json['status2'];
    approveBy2 = json['approve_by2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_l_id'] = this.docLId;
    data['leave_id'] = this.leaveId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['employee_no'] = this.employeeNo;
    data['company_id'] = this.companyId;
    data['description'] = this.description;
    data['create_at'] = this.createAt;
    if (this.leave != null) {
      data['Leave'] = this.leave!.toJson();
    }
    data['status'] = this.status;
    if (this.approveBy != null) {
      data['approve_by'] = this.approveBy!.map((v) => v.toJson()).toList();
    }
    data['status2'] = this.status2;
    data['approve_by2'] = this.approveBy2;
    return data;
  }
}

class Leave {
  int? rowId;
  String? leaveId;
  String? companyId;
  String? leaveType;
  String? amount;

  Leave(
      {this.rowId, this.leaveId, this.companyId, this.leaveType, this.amount});

  Leave.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    leaveId = json['leave_id'];
    companyId = json['company_id'];
    leaveType = json['leave_type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['leave_id'] = this.leaveId;
    data['company_id'] = this.companyId;
    data['leave_type'] = this.leaveType;
    data['amount'] = this.amount;
    return data;
  }
}

class ApproveBy {
  String? firstName;
  String? lastName;

  ApproveBy({this.firstName, this.lastName});

  ApproveBy.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
