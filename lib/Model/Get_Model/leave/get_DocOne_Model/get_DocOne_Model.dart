class get_doc_leavelist_one_Model {
  List<DocList>? docList;

  get_doc_leavelist_one_Model({this.docList});

  get_doc_leavelist_one_Model.fromJson(Map<String, dynamic> json) {
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
  String? status;
  Leave? leave;
  List<DocLeaveApprove>? docLeaveApprove;
  Employee? employee;

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
      this.status,
      this.leave,
      this.docLeaveApprove,
      this.employee});

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
    status = json['status'];
    leave = json['Leave'] != null ? new Leave.fromJson(json['Leave']) : null;
    if (json['Doc_Leave_Approve'] != null) {
      docLeaveApprove = <DocLeaveApprove>[];
      json['Doc_Leave_Approve'].forEach((v) {
        docLeaveApprove!.add(new DocLeaveApprove.fromJson(v));
      });
    }
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
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
    data['status'] = this.status;
    if (this.leave != null) {
      data['Leave'] = this.leave!.toJson();
    }
    if (this.docLeaveApprove != null) {
      data['Doc_Leave_Approve'] =
          this.docLeaveApprove!.map((v) => v.toJson()).toList();
    }
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
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

class DocLeaveApprove {
  String? approveFname;
  String? approveLname;
  String? status;

  DocLeaveApprove({this.approveFname, this.approveLname, this.status});

  DocLeaveApprove.fromJson(Map<String, dynamic> json) {
    approveFname = json['approve_fname'];
    approveLname = json['approve_lname'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approve_fname'] = this.approveFname;
    data['approve_lname'] = this.approveLname;
    data['status'] = this.status;
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
