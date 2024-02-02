class get_doc_leavelist_one {
  List<DocList>? docList;

  get_doc_leavelist_one({this.docList});

  get_doc_leavelist_one.fromJson(Map<String, dynamic> json) {
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
  String? approveBy;
  String? status2;
  String? approveBy2;
  Employee? employee;
  List<ApproveName>? approveName;

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
      this.approveBy2,
      this.employee,
      this.approveName});

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
    approveBy = json['approve_by'];
    status2 = json['status2'];
    approveBy2 = json['approve_by2'];
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    if (json['approve_name'] != null) {
      approveName = <ApproveName>[];
      json['approve_name'].forEach((v) {
        approveName!.add(new ApproveName.fromJson(v));
      });
    }
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
    data['approve_by'] = this.approveBy;
    data['status2'] = this.status2;
    data['approve_by2'] = this.approveBy2;
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
    }
    if (this.approveName != null) {
      data['approve_name'] = this.approveName!.map((v) => v.toJson()).toList();
    }
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

class Employee {
  String? firstName;
  String? lastName;

  Employee({this.firstName, this.lastName});

  Employee.fromJson(Map<String, dynamic> json) {
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
class ApproveName {
  String? firstName;
  String? lastName;

  ApproveName({this.firstName, this.lastName});

  ApproveName.fromJson(Map<String, dynamic> json) {
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