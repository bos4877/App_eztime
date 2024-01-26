class get_leave_Model {
  List<DocList>? docList;

  get_leave_Model({this.docList});

  get_leave_Model.fromJson(Map<String, dynamic> json) {
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
  int? rowId;
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
  String? file;
  String? status;
  String? approveBy;
  String? status2;
  String? approveBy2;
  Leave? leave;

  DocList(
      {this.rowId,
      this.docLId,
      this.leaveId,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.employeeNo,
      this.companyId,
      this.description,
      this.createAt,
      this.file,
      this.status,
      this.approveBy,
      this.status2,
      this.approveBy2,
      this.leave});

  DocList.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
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
    file = json['file'];
    status = json['status'];
    approveBy = json['approve_by'];
    status2 = json['status2'];
    approveBy2 = json['approve_by2'];
    leave = json['Leave'] != null ? new Leave.fromJson(json['Leave']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
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
    data['file'] = this.file;
    data['status'] = this.status;
    data['approve_by'] = this.approveBy;
    data['status2'] = this.status2;
    data['approve_by2'] = this.approveBy2;
    if (this.leave != null) {
      data['Leave'] = this.leave!.toJson();
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
