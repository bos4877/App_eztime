class get_doc_Ot_list_model {
  List<DocList>? docList;

  get_doc_Ot_list_model({this.docList});

  get_doc_Ot_list_model.fromJson(Map<String, dynamic> json) {
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
  String? docOtId;
  String? otId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? employeeNo;
  String? companyId;
  String? description;
  String? createAt;
  String? status;
  Ot? ot;
  Employee? employee;
  List<DocOtApprove>? docOtApprove;

  DocList(
      {this.docOtId,
      this.otId,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.employeeNo,
      this.companyId,
      this.description,
      this.createAt,
      this.status,
      this.ot,
      this.employee,
      this.docOtApprove});

  DocList.fromJson(Map<String, dynamic> json) {
    docOtId = json['doc_ot_id'];
    otId = json['ot_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    employeeNo = json['employee_no'];
    companyId = json['company_id'];
    description = json['description'];
    createAt = json['create_at'];
    status = json['status'];
    ot = json['Ot'] != null ? new Ot.fromJson(json['Ot']) : null;
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    if (json['Doc_Ot_Approve'] != null) {
      docOtApprove = <DocOtApprove>[];
      json['Doc_Ot_Approve'].forEach((v) {
        docOtApprove!.add(new DocOtApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_ot_id'] = this.docOtId;
    data['ot_id'] = this.otId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['employee_no'] = this.employeeNo;
    data['company_id'] = this.companyId;
    data['description'] = this.description;
    data['create_at'] = this.createAt;
    data['status'] = this.status;
    if (this.ot != null) {
      data['Ot'] = this.ot!.toJson();
    }
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
    }
    if (this.docOtApprove != null) {
      data['Doc_Ot_Approve'] =
          this.docOtApprove!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ot {
  int? rowId;
  String? otId;
  String? otName;
  String? rate;
  String? companyId;

  Ot({this.rowId, this.otId, this.otName, this.rate, this.companyId});

  Ot.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    otId = json['ot_id'];
    otName = json['ot_name'];
    rate = json['rate'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['ot_id'] = this.otId;
    data['ot_name'] = this.otName;
    data['rate'] = this.rate;
    data['company_id'] = this.companyId;
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

class DocOtApprove {
  String? docOtApproveId;
  String? docOtId;
  String? status;
  String? approveBy;
  String? createAt;
  String? approveFname;
  String? approveLname;

  DocOtApprove(
      {this.docOtApproveId,
      this.docOtId,
      this.status,
      this.approveBy,
      this.createAt,
      this.approveFname,
      this.approveLname});

  DocOtApprove.fromJson(Map<String, dynamic> json) {
    docOtApproveId = json['doc_ot_approve_id'];
    docOtId = json['doc_ot_id'];
    status = json['status'];
    approveBy = json['approve_by'];
    createAt = json['create_at'];
    approveFname = json['approve_fname'];
    approveLname = json['approve_lname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_ot_approve_id'] = this.docOtApproveId;
    data['doc_ot_id'] = this.docOtId;
    data['status'] = this.status;
    data['approve_by'] = this.approveBy;
    data['create_at'] = this.createAt;
    data['approve_fname'] = this.approveFname;
    data['approve_lname'] = this.approveLname;
    return data;
  }
}
